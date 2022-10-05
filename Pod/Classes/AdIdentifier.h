//
//  AdIdentifier.h
//  EAnalytics
//
//  Created by FRouault on 07/06/2015.
//  Copyright (c) 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdIdentifier : NSObject

+ (NSString *) idfa;
+ (BOOL) adTrackingEnabled;
+ (BOOL) hasAdSupportFrameworkAdded;

@end
