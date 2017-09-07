//
//  EAOSiteCentricCFlag.m
//  Pods
//
//  Created by François Rouault on 07/09/2017.
//
//

#import "EAOSiteCentricCFlag.h"

@implementation EAOSiteCentricCFlag

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
