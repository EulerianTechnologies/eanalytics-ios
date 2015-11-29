//
//  EACart.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EACart.h"

@implementation EACart

static NSString* const KEY_SCART = @"scart";
static NSString* const KEY_CUMUL = @"scartcumul";
static NSString* const KEY_PRODUCT_AMOUNT = @"amount";
static NSString* const KEY_PRODUCT_QUANTITY = @"quantity";
static NSString* const KEY_PRODUCTS = @"products";

- (instancetype)initWithPath:(NSString *)path
{
    self = [super initWithPath:path];
    if (self) {
        [self setEulerianWithValue:@"1" forKey:KEY_SCART];
    }
    return self;
}

- (void)setEulerianWithCumul:(BOOL)value
{
    NSNumber *valueInt = [NSNumber numberWithInt:(value ? 1 : 0)];
    [self setEulerianWithValue:valueInt forKey:KEY_CUMUL];
}

- (void)addEulerian:(EAOProduct*)product amount:(double)amout quantity:(int)quantity
{
    NSMutableArray *array = nil;
    if ([self.dictionary objectForKey:KEY_PRODUCTS]) {
        NSArray *currentArray = [self.dictionary objectForKey:KEY_PRODUCTS];
        array = [NSMutableArray arrayWithArray:currentArray];
    } else {
        array = [[NSMutableArray alloc] init];
    }
    [product.dictionary setObject:[NSNumber numberWithDouble:amout] forKey:KEY_PRODUCT_AMOUNT];
    [product.dictionary setObject:[NSNumber numberWithInt:quantity] forKey:KEY_PRODUCT_QUANTITY];
    [array addObject:product.dictionary];
    [self setEulerianWithValue:array forKey:KEY_PRODUCTS];
}

@end
