//
//  EAOrder.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAOrder.h"
#import "EAAssertion.h"
#import "NSMutableDictionary+Utils.h"

@implementation EAOrder

static NSString* const KEY_REF = @"ref";
static NSString* const KEY_SALE_AMOUNT = @"amount";
static NSString* const KEY_CURRENCY = @"currency";
static NSString* const KEY_ESTIMATE_REF = @"estimateref";
static NSString* const KEY_TYPE = @"type";
static NSString* const KEY_PAYMENT = @"payment";
static NSString* const KEY_PRODUCTS = @"products";
static NSString* const KEY_PRODUCT_AMOUNT = @"amount";
static NSString* const KEY_PRODUCT_QUANTITY = @"quantity";

- (instancetype)initWithPath:(NSString *)path withRef:(NSString*)ref
{
    self = [super initWithPath:path];
    if (self) {
        [self setEulerianWithValue:ref forKey:KEY_REF];
    }
    return self;
}

- (void)setEulerianWithAmount:(double)value
{
    [self setEulerianWithValue:[[NSNumber numberWithDouble:value] stringValue] forKey: KEY_SALE_AMOUNT];
}

- (void)setEulerianWithCurrency:(NSString*)value
{
    [self setEulerianWithValue:value forKey: KEY_CURRENCY];
}

- (void)setEulerianWithType:(NSString*)value
{
    [self setEulerianWithValue:value forKey: KEY_TYPE];
}

- (void)setEulerianWithPayment:(NSString*)value
{
    [self setEulerianWithValue:value forKey: KEY_PAYMENT];
}

- (void)setEulerianWithEstimateRef:(NSString*)value
{
    [self setEulerianWithValue:value forKey: KEY_ESTIMATE_REF];
}

- (void)addEulerian:(EAOProduct*)product amount:(double)amout quantity:(int)quantity
{
    [EAAssertion warnCondition:(quantity > 0) withMessage:[NSString stringWithFormat:@"Quantity might be > 0 when adding product '%@'", product.dictionary.json]];
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
