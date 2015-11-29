//
//  AdIdentifier.m
//  EAnalytics
//
//  Created by FRouault on 07/06/2015.
//  Copyright (c) 2015 Eulerian Technologies. All rights reserved.
//

#import "AdIdentifier.h"

@implementation AdIdentifier

+ (NSString *) idfa
{
    NSString* idForAdvertiser = nil;
    Class identifierManager = NSClassFromString(@"ASIdentifierManager");
    if (identifierManager) {
        SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
        id sharedManager = ((id (*)(id, SEL))[identifierManager methodForSelector:sharedManagerSelector])(identifierManager, sharedManagerSelector);
        SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
        NSUUID *uuid = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
        idForAdvertiser = [uuid UUIDString];
    }
    return idForAdvertiser;
}

+ (BOOL) adTrackingEnabled
{
    BOOL result = NO;
    Class advertisingManager = NSClassFromString(@"ASIdentifierManager");
    SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
    id sharedManager = ((id (*)(id, SEL))[advertisingManager methodForSelector:sharedManagerSelector])(advertisingManager, sharedManagerSelector);
    SEL adTrackingEnabledSEL = NSSelectorFromString(@"isAdvertisingTrackingEnabled");
    result = ((BOOL (*)(id, SEL))[sharedManager methodForSelector:adTrackingEnabledSEL])(sharedManager, adTrackingEnabledSEL);
    return result;
}

+ (BOOL) hasAdSupportFrameworkAdded
{
    Class identifierManager = NSClassFromString(@"ASIdentifierManager");
    if (identifierManager) {
        return YES;
    } else {
        return NO;
    }
}


@end
