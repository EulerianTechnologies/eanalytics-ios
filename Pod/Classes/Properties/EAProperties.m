//
//  EAProperties.m
//  EAnalytics
//
//  Created by FRouault on 21/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAProperties.h"
#import "UIDevice+Utils.h"
#import "AdIdentifier.h"
#import "EAAssertion.h"
#import "NSMutableDictionary+Utils.h"

@implementation EAProperties

//- keys internal infos
static NSString* const KEY_GLOBAL_EOS = @"eos";
static NSString* const KEY_GLOBAL_EHW = @"ehw";
static NSString* const KEY_GLOBAL_EHW_IDENTIFIER = @"ehw-identifier";
static NSString* const KEY_GLOBAL_URL = @"url";
static NSString* const KEY_GLOBAL_APPNAME = @"ea-appname";
static NSString* const KEY_GLOBAL_EPOCH = @"ereplay-time";
static NSString* const KEY_GLOBAL_IDFV = @"ea-ios-idfv";
static NSString* const KEY_GLOBAL_IDFA = @"ea-ios-idfa";
static NSString* const KEY_GLOBAL_ADTRACKING_ENABLED = @"ea-iso-islat";
static NSString* const KEY_GLOBAL_APP_VERSION = @"ea-appversion";
static NSString* const KEY_GLOBAL_APP_BUILD = @"ea-appversionbuild";
//- keys pages
static NSString* const KEY_PAGE_PATH = @"path";
static NSString* const KEY_PAGE_LATITUDE = @"ea-lat";
static NSString* const KEY_PAGE_LONGITUDE = @"ea-lon";
static NSString* const KEY_PAGE_EMAIL = @"email";
static NSString* const KEY_PAGE_UID = @"uid";
static NSString* const KEY_PAGE_PROFILE = @"profile";
static NSString* const KEY_PAGE_GROUP = @"pagegroup";
static NSString* const KEY_PAGE_ACTION = @"action";
static NSString* const KEY_PAGE_PROPERTY = @"property";
static NSString* const KEY_PAGE_NEW_CUSTOMER = @"newcustomer";

- (NSString *)json
{
    return _dictionary.json;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [EAAssertion assertCondition:false withMessage:@"Use library constructor"];
    }
    return self;
}

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        [EAAssertion assertCondition:(path != nil) withMessage:@"Path cannot be undefined"];
        
        // MARK: - internal params
        
        _dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [[UIDevice currentDevice] systemVersion], KEY_GLOBAL_EOS,
                       [[UIDevice currentDevice] model], KEY_GLOBAL_EHW,
                       [[UIDevice currentDevice] platform], KEY_GLOBAL_EHW_IDENTIFIER,
                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], KEY_GLOBAL_APP_VERSION,
                       [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], KEY_GLOBAL_APP_BUILD,
                       nil];
        
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        if (bundleIdentifier) {
            [_dictionary setObject:bundleIdentifier forKey:KEY_GLOBAL_APPNAME];
            [_dictionary setObject:[NSString stringWithFormat:@"http://%@", bundleIdentifier] forKey:KEY_GLOBAL_URL];
        }
        
        int epoch = (int) [[[NSDate alloc] init] timeIntervalSince1970];
        [_dictionary setObject:[@(epoch) stringValue] forKey:KEY_GLOBAL_EPOCH];
        
        NSUUID *idfv = [[UIDevice currentDevice] identifierForVendor];
        [_dictionary setObject:[idfv UUIDString] forKey:KEY_GLOBAL_IDFV];
        
        if ([AdIdentifier hasAdSupportFrameworkAdded]) {
            [_dictionary setObject:([AdIdentifier adTrackingEnabled] ? @"true" : @"false") forKey:KEY_GLOBAL_ADTRACKING_ENABLED];
            [_dictionary setObject:[AdIdentifier idfa] forKey:KEY_GLOBAL_IDFA];
        }
        
        // MARK: - default page params
        
        if (![[path substringToIndex:0] isEqualToString:@"/"]) {
            path = [NSString stringWithFormat:@"/%@", path];
        }
        [_dictionary setObject:path forKey:KEY_PAGE_PATH];
    }
    return self;
}

// MARK: - Page params

- (void)setEulerianWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    [_dictionary setObject:[[NSNumber numberWithDouble:latitude] stringValue] forKey:KEY_PAGE_LATITUDE];
    [_dictionary setObject:[[NSNumber numberWithDouble:longitude] stringValue] forKey:KEY_PAGE_LONGITUDE];
}

- (void)setEulerianWithLocation:(CLLocationCoordinate2D) location
{
    [self setEulerianWithLatitude:location.latitude longitude:location.longitude];
}

- (void)setEulerianWithEmail:(NSString*)value
{
    [_dictionary setObject:value forKey:KEY_PAGE_EMAIL];
}

- (void)setEulerianWithUid:(NSString*)value
{
    [_dictionary setObject:value forKey:KEY_PAGE_UID];
}

- (void)setEulerianWithProfile:(NSString*)value
{
    [_dictionary setObject:value forKey:KEY_PAGE_PROFILE];
}

- (void)setEulerianWithPageGroup:(NSString*)value
{
    [_dictionary setObject:value forKey:KEY_PAGE_GROUP];
}

- (void)setEulerianWithNewCustomer:(BOOL)value
{
    if (value) {
        [_dictionary setObject:@"1" forKey:KEY_PAGE_NEW_CUSTOMER];
    }
}

- (void)setEulerianWithAction:(EAOAction *)value
{
    [value checkConformity];
    [_dictionary setObject:value.dictionary forKey:KEY_PAGE_ACTION];
}

- (void)setEulerianWithProperties:(EAOSiteCentricProperties*)value
{
    [_dictionary setObject:value.dictionary forKey:KEY_PAGE_PROPERTY];
}

// MARK : other values

- (void)setEulerianWithValue:(id)value forKey:(NSString *)key
{
    [_dictionary setObject:value forKey:key];
}

@end
