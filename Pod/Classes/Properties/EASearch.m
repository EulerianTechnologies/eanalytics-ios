//
//  EASearch.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EASearch.h"

@implementation EASearch

static NSString* const KEY_NAME = @"name";
static NSString* const KEY_RESULTS = @"results";
static NSString* const KEY_PARAMS = @"params";
static NSString* const KEY_SEARCH_ENGINE = @"isearchengine";

NSMutableDictionary *engine;

- (instancetype)initWithPath:(NSString *)path withName:(NSString*)name
{
    self = [super initWithPath:path];
    if (self) {
        engine = [[NSMutableDictionary alloc] init];
        [self setEulerianWithValue:name forKey:KEY_NAME];
        [self setEngine];
    }
    return self;
}

- (void) setEulerianWithResults:(int)value
{
    [engine setObject:[NSNumber numberWithInt:value] forKey:KEY_RESULTS];
    [self setEngine];
}

- (void) setEulerianWithParams:(EAOParams*)value
{
    [engine setObject:value.dictionary forKey:KEY_PARAMS];
    [self setEngine];
}

- (void) setEngine {
    [self setEulerianWithValue:engine forKey:KEY_SEARCH_ENGINE];
}

@end
