//
//  EAnalytics.m
//  EAnalytics
//
//  Created by FRouault on 21/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAnalytics.h"
#import "AdIdentifier.h"
#import "EAAssertion.h"
#import "Utils.h"
#import "NSData+GZIP.h"
#import "EATpClick.h"
#import "EATpView.h"

@implementation EAnalytics

static NSString* const USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY = @"eulerian-untracked-properties";
static NSString* const USER_DEFAULT_EUIDL = @"eulerian-euidl";
static NSString* const USER_DEFAULT_LOOKUP_SENT = @"eulerian-lookup-already-sent";
//TODO: static int const MAX_UNZIPPED_BYTES_PER_SEND = 100000;
static NSString* const KEY_LOOKUP = @"ea-uid-lookup";
static NSString* const KEY_GLOBAL_EUIDL = @"euidl";
static NSString* const KEY_GLOBAL_SDK_VERSION = @"ea-ios-sdk-version";
static NSString* const KEY_TYPE = @"type";
static NSString* const TYPE_TPVIEW = @"EATpView";
static NSString* const TYPE_TPCLICK = @"EATpClick";

static BOOL sDebug;
static NSString *sSTDomain;
static NSString *sClickDomain;
static NSString *sViewDomain;

dispatch_queue_t serialQueue;

//- MARK: var

+ (NSString *)version
{
    return @"1.5.0";
}

+ (NSString*)euidl {
    NSString *temp = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_EUIDL];
    if (temp) {
        return temp;
    }
    NSString *euidl = [[NSUUID UUID] UUIDString];
    [[NSUserDefaults standardUserDefaults] setValue:euidl forKey:USER_DEFAULT_EUIDL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return euidl;
}

//- MARK: methods

+ (void)initWithHost:(NSString *)host andWithDebugLogs:(BOOL) debug
{
    [EAAssertion assertCondition:[Utils testHost:host] withMessage:[NSString stringWithFormat:@"Host '%@' is not valid", host]];
    [EAAssertion assertCondition:([host rangeOfString:@".eulerian.com"].location == NSNotFound) withMessage: @"Host cannot contain '.eulerian.com'"];
    NSString *adSupportDetectedMsg = [AdIdentifier hasAdSupportFrameworkAdded] ? @"AdSupport framework detected" : @"AdSupport framework not detected -> IDFA will not be provided";
    NSLog(@"EULERIAN ANALYTICS : initialized with %@. Running lib v%@. %@.", host, [EAnalytics version], adSupportDetectedMsg);
    sDebug = debug;
    sSTDomain = [NSString stringWithFormat:@"https://%@/collectorjson/-/", host];
    sClickDomain = [NSString stringWithFormat:@"https://%@/tpclick/", host];
    sViewDomain = [NSString stringWithFormat:@"https://%@/tpview/", host];
    serialQueue = dispatch_queue_create("com.eulerian.serial.queue", DISPATCH_QUEUE_SERIAL);

    [self checkForStoredProperties];
}

+ (void)checkForStoredProperties
{
    dispatch_async(serialQueue, ^{
        NSArray* untracked = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
        if ([untracked count] == 0) {
            if (sDebug) {
                NSLog(@"EULERIAN ANALYTICS : No stored properties found. Continue.");
            }
            return;
        }
        if (sDebug) {
            NSLog(@"EULERIAN ANALYTICS : %d stored properties found. Will try to send them.", (int) [untracked count]);
        }

        NSMutableArray *genericPending = [NSMutableArray array];
        NSMutableArray *stillUntracked = [NSMutableArray array];

        for (NSDictionary *entry in untracked) {
            NSString *type = [entry isKindOfClass:[NSDictionary class]] ? entry[KEY_TYPE] : nil;
            if ([TYPE_TPVIEW isEqualToString:type] || [TYPE_TPCLICK isEqualToString:type]) {
                BOOL success = [EAnalytics httpGetTypedEntry:entry];
                if (!success) {
                    [stillUntracked addObject:entry];
                }
            } else {
                [genericPending addObject:entry];
            }
        }

        if (genericPending.count > 0) {
            BOOL success = [EAnalytics httpPostProperties:genericPending];
            if (!success) {
                [stillUntracked addObjectsFromArray:genericPending];
            }
        }

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (stillUntracked.count > 0) {
            [defaults setObject:stillUntracked forKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
            if (sDebug) {
                NSLog(@"EULERIAN ANALYTICS : %d stored properties still pending. Will retry later.", (int)stillUntracked.count);
            }
        } else {
            [defaults removeObjectForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
        }
        [defaults synchronize];
    });
}

+ (void)track:(EAProperties *)properties
{
    dispatch_async(serialQueue, ^{
        [properties setEulerianWithValue:[EAnalytics euidl] forKey:KEY_GLOBAL_EUIDL];
        [properties setEulerianWithValue:[EAnalytics version] forKey:KEY_GLOBAL_SDK_VERSION];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:USER_DEFAULT_LOOKUP_SENT]) {
            [properties setEulerianWithValue:[NSNumber numberWithInt:1] forKey: KEY_LOOKUP];
            [defaults setBool:NO forKey:USER_DEFAULT_LOOKUP_SENT];
        }
        if (sDebug) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:properties.dictionary options:0 error:nil];
            NSString *log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"EULERIAN ANALYTICS : Tracking :%@", log);
        }

        BOOL isTpView = [properties isKindOfClass:[EATpView class]];
        BOOL isTpClick = [properties isKindOfClass:[EATpClick class]];

        if (isTpView || isTpClick) {
            BOOL success = [EAnalytics httpGetForProperties:properties];
            if (success) {
                if (sDebug) NSLog(@"EULERIAN ANALYTICS : Track succeeded.");
            } else {
                if (sDebug) NSLog(@"EULERIAN ANALYTICS : Track failed. Will retry later.");
                [EAnalytics appendUntracked:properties.dictionary];
            }
            return;
        }

        // Generic event: batch with previously untracked
        NSMutableArray *track = [NSMutableArray arrayWithObject:properties.dictionary];
        NSArray* untracked = [defaults arrayForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
        NSMutableArray *carriedTyped = [NSMutableArray array];
        if (untracked) {
            for (NSDictionary *entry in untracked) {
                NSString *type = [entry isKindOfClass:[NSDictionary class]] ? entry[KEY_TYPE] : nil;
                if ([TYPE_TPVIEW isEqualToString:type] || [TYPE_TPCLICK isEqualToString:type]) {
                    [carriedTyped addObject:entry];
                } else {
                    [track addObject:entry];
                }
            }
            if (sDebug && (track.count - 1) > 0) {
                NSLog(@"add %d stored properties to the current track.", (int)(track.count - 1));
            }
        }
        BOOL success = [EAnalytics httpPostProperties:track];
        if (success) {
            if (sDebug) NSLog(@"EULERIAN ANALYTICS : Track succeeded.");
            if (carriedTyped.count > 0) {
                [defaults setObject:carriedTyped forKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
            } else {
                [defaults removeObjectForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
            }
        } else {
            if (sDebug) NSLog(@"EULERIAN ANALYTICS : Track failed. Will retry later.");
            NSMutableArray *toStore = [NSMutableArray arrayWithArray:track];
            [toStore addObjectsFromArray:carriedTyped];
            [defaults setObject:toStore forKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
        }
        [defaults synchronize];
    });
}

+ (void)appendUntracked:(NSDictionary *)entry
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *current = [defaults arrayForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
    NSMutableArray *next = current ? [current mutableCopy] : [NSMutableArray array];
    [next addObject:entry];
    [defaults setObject:next forKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
    [defaults synchronize];
}

+ (BOOL)httpGetForProperties:(EAProperties *)properties
{
    NSString *base = nil;
    NSString *query = nil;
    if ([properties isKindOfClass:[EATpView class]]) {
        base = sViewDomain;
        query = [(EATpView *)properties toQueryString];
    } else if ([properties isKindOfClass:[EATpClick class]]) {
        base = sClickDomain;
        query = [(EATpClick *)properties toQueryString];
    } else {
        return NO;
    }
    return [EAnalytics performHttpGetWithBase:base query:query];
}

+ (BOOL)httpGetTypedEntry:(NSDictionary *)entry
{
    NSString *type = entry[KEY_TYPE];
    EAProperties *restored = nil;
    if ([TYPE_TPVIEW isEqualToString:type]) {
        restored = [EAnalytics restoreEATpView:entry];
    } else if ([TYPE_TPCLICK isEqualToString:type]) {
        restored = [EAnalytics restoreEATpClick:entry];
    }
    if (restored == nil) {
        return NO;
    }
    return [EAnalytics httpGetForProperties:restored];
}

+ (EATpView *)restoreEATpView:(NSDictionary *)entry
{
    NSString *path = entry[@"path"] ?: @"/";
    EATpView *v = [[EATpView alloc] initWithPath:path];
    NSArray *dyntpview = entry[@"dyntpview"];
    if ([dyntpview isKindOfClass:[NSArray class]] && dyntpview.count >= 7) {
        [v setSiteName:[dyntpview[0] description]];
        [v setCampaign:[dyntpview[1] description]];
        [v setPlacement:[dyntpview[2] description]];
        [v setPublisher:[dyntpview[3] description]];
        [v setMedia:[dyntpview[4] description]];
        [v setCategory:[dyntpview[5] description]];
        [v setUrl:[dyntpview[6] description]];
    }
    NSArray *products = entry[@"tpviewprd"];
    if ([products isKindOfClass:[NSArray class]]) {
        for (NSArray *prod in products) {
            if (![prod isKindOfClass:[NSArray class]] || prod.count == 0) continue;
            NSString *ref = [prod[0] description];
            NSNumber *pos = prod.count > 1 && [prod[1] isKindOfClass:[NSNumber class]] ? prod[1] : nil;
            [v addProductWithRef:ref position:pos];
        }
    }
    return v;
}

+ (EATpClick *)restoreEATpClick:(NSDictionary *)entry
{
    NSString *path = entry[@"path"] ?: @"/";
    EATpClick *c = [[EATpClick alloc] initWithPath:path];
    NSArray *dyntpclick = entry[@"dyntpclick"];
    if ([dyntpclick isKindOfClass:[NSArray class]] && dyntpclick.count >= 6) {
        [c setSiteName:[dyntpclick[0] description]];
        [c setCampaign:[dyntpclick[1] description]];
        [c setPlacement:[dyntpclick[2] description]];
        [c setPublisher:[dyntpclick[3] description]];
        [c setMedia:[dyntpclick[4] description]];
        [c setCategory:[dyntpclick[5] description]];
    }
    NSDictionary *product = entry[@"tpclickproduct"];
    if ([product isKindOfClass:[NSDictionary class]]) {
        NSString *ref = [product[@"ref"] ?: @"" description];
        NSInteger position = [product[@"position"] integerValue];
        NSNumber *total = [product[@"totalProducts"] isKindOfClass:[NSNumber class]] ? product[@"totalProducts"] : nil;
        [c setProductWithRef:ref position:position totalProducts:total];
    }
    return c;
}

+ (BOOL)performHttpGetWithBase:(NSString *)base query:(NSString *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", base, query ?: @""];
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        if (sDebug) NSLog(@"EULERIAN ANALYTICS : Invalid GET URL >>>> %@", urlString);
        return NO;
    }
    if (sDebug) NSLog(@"EULERIAN ANALYTICS : GET >>>> %@", urlString);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:5.0];

    __block NSData *responseData = nil;
    __block NSURLResponse *response = nil;
    __block NSError *requestError = nil;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable d, NSURLResponse * _Nullable r, NSError * _Nullable e) {
        responseData = d;
        response = r;
        requestError = e;
        dispatch_semaphore_signal(sema);
    }];
    [task resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    if (requestError) {
        if (sDebug) NSLog(@"EULERIAN ANALYTICS : GET request failed >>>> %@", requestError.debugDescription);
        return NO;
    }
    NSInteger status = [response isKindOfClass:[NSHTTPURLResponse class]] ? ((NSHTTPURLResponse *)response).statusCode : 0;
    if (sDebug) NSLog(@"EULERIAN ANALYTICS : GET response status %ld", (long)status);
    return (status >= 200 && status < 300);
}

+ (BOOL)httpPostProperties:(NSArray*)props
{
    //Prepare data
    NSData *data = [NSJSONSerialization dataWithJSONObject:props options:0 error:nil];

    if (sDebug) {
        NSString *log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"EULERIAN ANALYTICS : Posting >>>> %@", log);
    }

    NSData *requestBodyData = [data gzippedData];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long) requestBodyData.length];

    NSString *urlString = [NSString stringWithFormat:@"%@%d", sSTDomain, (int) [NSDate date].timeIntervalSince1970];
    NSURL *url = [NSURL URLWithString:urlString];

    //Build Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    [request setHTTPBody:requestBodyData];

    //Send the request
    NSError *requestError;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: &requestError];

    if (requestError) {
        if (sDebug) {
            NSLog(@"EULERIAN ANALYTICS : Request failed >>>> %@", requestError.debugDescription);
        }
        return NO;
    }

    //Get the Result of Request
    NSError *responseError;
    NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&responseError];

    if (responseError) {
        if (sDebug) {
            NSLog(@"EULERIAN ANALYTICS : Read response failed >>>> %@", requestError.debugDescription);
        }
        return NO;
    }

    if (sDebug) {
        NSString *log = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
        NSLog(@"EULERIAN ANALYTICS : Response >>>> %@", log);
    }

    //Check result
    NSNumber *errorValue = (NSNumber *)[responseDic valueForKey:@"error"];
    return ![errorValue boolValue];
}

@end
