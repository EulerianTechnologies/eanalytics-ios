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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setEulerianWithRef:(NSString *) value
{
    [_dictionary setObject:value forKey:KEY_REF];
}

- (void) setEulerianWithInValue:(NSString *) value
{
    [_dictionary setObject:value forKey:KEY_IN];
}

- (void) setEulerianWithOutValues:(NSArray *) values
{
    [_dictionary setObject:values forKey:KEY_OUT];
}

- (void) checkConformity
{
    id hasIn = [_dictionary objectForKey:KEY_IN];
    id hasOut = [_dictionary objectForKey:KEY_OUT];
    [EAAssertion warnCondition:(hasIn && hasOut) withMessage:@"EAAction must contain both 'in' and 'out' keys to be valid."];
}

@end
