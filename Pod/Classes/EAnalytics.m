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

@implementation EAnalytics

static NSString* const USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY = @"eulerian-untracked-properties";
static NSString* const USER_DEFAULT_EUIDL = @"eulerian-euidl";
static NSString* const USER_DEFAULT_LOOKUP_SENT = @"eulerian-lookup-already-sent";
//TODO: static int const MAX_UNZIPPED_BYTES_PER_SEND = 100000;
static NSString* const KEY_LOOKUP = @"ea-uid-lookup";
static NSString* const KEY_GLOBAL_EUIDL = @"euidl";
static NSString* const KEY_GLOBAL_SDK_VERSION = @"ea-ios-sdk-version";

static BOOL sDebug;
static NSString *sSTDomain;

dispatch_queue_t serialQueue;

//- MARK: var

+ (NSString *)version
{
    return @"1.3.6";
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
    serialQueue = dispatch_queue_create("com.eulerian.serial.queue", DISPATCH_QUEUE_SERIAL);
    
    [self checkForStoredProperties];
}

+ (void)checkForStoredProperties
{
    dispatch_async(serialQueue, ^{
        //block
        NSArray* untracked = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
        if ([untracked count]>0) {
            if (sDebug) {
                NSLog(@"EULERIAN ANALYTICS : %d stored properties found. Will try to send them.", (int) [untracked count]);
            }
            BOOL success = [EAnalytics httpPostProperties:untracked];
            if (success) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else if (sDebug) {
                NSLog(@"EULERIAN ANALYTICS : Failed to save stored properties. Will retry later.");
            }
        } else if (sDebug) {
            NSLog(@"EULERIAN ANALYTICS : No stored properties found. Continue.");
        }
    });
}

+ (void)track:(EAProperties *)properties
{
    dispatch_async(serialQueue, ^{
        [properties setEulerianWithValue:[EAnalytics euidl] forKey:KEY_GLOBAL_EUIDL];
        [properties setEulerianWithValue:[EAnalytics version] forKey:KEY_GLOBAL_SDK_VERSION];
        //block
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
        NSMutableArray *track = [NSMutableArray arrayWithObject:properties.dictionary];
        NSArray* untracked = [defaults arrayForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
        if (untracked) {
            if (sDebug) {
                NSLog(@"add %d stored properties to the current track.", (int)[untracked count]);
            }
            [track addObjectsFromArray:untracked];
        }
        BOOL success = [EAnalytics httpPostProperties:track];
        if (success) {
            if (sDebug) {
                NSLog(@"EULERIAN ANALYTICS : Track succeeded.");
            }
            [defaults removeObjectForKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
        } else {
            if (sDebug) {
                NSLog(@"EULERIAN ANALYTICS : Track failed. Will retry later.");
            }
            [defaults setObject:track forKey:USER_DEFAULT_UNTRACKED_PROPERTIES_ARRAY];
        }
        [defaults synchronize];
    });
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
