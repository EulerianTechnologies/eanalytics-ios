//
//  EAOProduct.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAOProduct.h"

@implementation EAOProduct

static NSString* const KEY_REF = @"ref";
static NSString* const KEY_NAME = @"name";
static NSString* const KEY_PARAMS = @"params";
static NSString* const KEY_GROUP = @"group";

- (instancetype)initWithRef:(NSString*) ref
{
    self = [super init];
    if (self) {
        _dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       ref, KEY_REF,
                       nil];
    }
    return self;
}

- (void) setEulerianWithName:(NSString*)value
{
    [_dictionary setObject:value forKey:KEY_NAME];
}

- (void) setEulerianWithGroup:(NSString*)value
{
    [_dictionary setObject:value forKey:KEY_GROUP];
}

- (void) setEulerianWithParams:(EAOParams*)value
{
    [_dictionary setObject:value.dictionary forKey:KEY_PARAMS];
}

@end
