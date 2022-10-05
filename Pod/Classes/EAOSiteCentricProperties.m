//
//  EAOSiteCentricProperties.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAOSiteCentricProperties.h"

@implementation EAOSiteCentricProperties

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setEulerianWithValues:(NSArray *)values forKey:(NSString *)key
{
    [_dictionary setObject:values forKey:key];
}

@end
