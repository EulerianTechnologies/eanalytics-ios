//
//  EAProducts.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAProducts.h"
#import "EAOProduct.h"

@implementation EAProducts

static NSString* const KEY_PRODUCTS = @"products";

- (void) setEulerianWithProducts:(NSArray*)eaoproducts
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (EAOProduct *item in eaoproducts) {
        [array addObject:item.dictionary];
    }
    [self setEulerianWithValue:array forKey:KEY_PRODUCTS];
}

@end
