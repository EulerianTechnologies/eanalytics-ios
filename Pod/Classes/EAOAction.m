//
//  EAOAction.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAOAction.h"
#import "EAAssertion.h"

@implementation EAOAction

static NSString* const KEY_REF = @"ref";
static NSString* const KEY_IN = @"in";
static NSString* const KEY_OUT = @"out";

static NSString* const KEY_NAME = @"name";
static NSString* const KEY_MODE = @"mode";
static NSString* const KEY_LABEL = @"label";
static NSString* const KEY_PARAMS = @"params";

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setEulerianWithRef:(NSString *) value
{
    [_dictionary setObject:value forKey:KEY_REF];
}

- (void)setEulerianWithName:(NSString *)value
{
    [_dictionary setObject:value forKey:KEY_NAME];
}

- (void)setEulerianWithMode:(NSString *)value
{
    [_dictionary setObject:value forKey:KEY_MODE];
}

- (void)setEulerianWithLabel:(NSString *)value
{
    [_dictionary setObject:value forKey:KEY_LABEL];
}

- (void)setEulerianWithParams:(EAOParams *)value
{
    [_dictionary setObject:value.dictionary forKey:KEY_PARAMS];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (void)setEulerianWithInValue:(NSString *) value
{
    [_dictionary setObject:value forKey:KEY_IN];
}

- (void)setEulerianWithOutValues:(NSArray *) values
{
    [_dictionary setObject:values forKey:KEY_OUT];
}

#pragma clang diagnostic pop

- (void)checkConformity
{
    id hasMode = [_dictionary objectForKey:KEY_MODE];
    id hasIn = [_dictionary objectForKey:KEY_IN];
    id hasOut = [_dictionary objectForKey:KEY_OUT];
    BOOL legacyValid = (hasIn || hasOut);
    BOOL newValid = (hasMode != nil);
    [EAAssertion warnCondition:(newValid || legacyValid) withMessage:@"EAAction must contain 'mode' (preferred) or 'in'/'out' (legacy) keys to be valid."];
}

@end
