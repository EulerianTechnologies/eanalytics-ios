//
//  EAOParams.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAOParams.h"

@implementation EAOParams

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setEulerianWithStringValue:(NSString*)value forKey:(NSString*)key
{
    [_dictionary setObject:value forKey:key];
}

- (void) setEulerianWithIntValue:(int)value forKey:(NSString*)key
{
    [_dictionary setObject:[NSNumber numberWithInteger:value] forKey:key];
}

@end
