//
//  EAViewController.m
//  EAnalytics
//
//  Created by François Rouault on 11/29/2015.
//  Copyright (c) 2015 François Rouault. All rights reserved.
//

#import "EAViewController.h"
#import "EAnalytics/EAnalytics.h"

@interface EAViewController ()

@end

@implementation EAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [EAnalytics initWithHost:@"ett.eulerian.net" andWithDebugLogs:YES];
    
    NSLog(@"euidl : %@", [EAnalytics euidl]);
    NSLog(@"EAnalytics version : %@", [EAnalytics version]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButton:(id)sender
{
    [EAnalytics track:[self createProducts]];
}

- (EAProperties*)createProperties
{
    EAProperties *prop = [[EAProperties alloc] initWithPath:@"my_prop_path"];
    [prop setEulerianWithEmail:@"test@toto.com"];
    [prop setEulerianWithValue:@"custom_value" forKey:@"custom_key"];
    [prop setEulerianWithLatitude:1.34453 longitude:2.34245325];
    [prop setEulerianWithAction:[self createAction]];
    [prop setEulerianWithProperties:[self createSiteCentric]];
    return prop;
}

- (EAOAction*)createAction
{
    EAOAction *action = [[EAOAction alloc] init];
    [action setEulerianWithInValue:@"my_in_value"];
    [action setEulerianWithRef:@"my_action_ref"];
    [action setEulerianWithOutValues:@[@"my_out_0", @"my_out_1", @"my_out_2" ]];
    return action;
}

- (EAOSiteCentricProperties *)createSiteCentric
{
    EAOSiteCentricProperties *siteCentric = [[EAOSiteCentricProperties alloc] init];
    [siteCentric setEulerianWithValues:@[@"my_value_site_centric_0", @"my_value_site_centric_1"] forKey:@"my_key_site_centric"];
    return siteCentric;
}

- (EAProducts *)createProducts
{
    EAProducts *products = [[EAProducts alloc] initWithPath:@"my_products_path"];
    [products setEulerianWithProducts:@[[self createProduct0], [self createProduct1], [self createProduct2]]];
    return products;
}

- (EAOParams*)createParams0
{
    EAOParams *params0 = [[EAOParams alloc] init];
    [params0 setEulerianWithIntValue:3 forKey:@"my_int_param_key"];
    [params0 setEulerianWithStringValue:@"my_string_param_value" forKey:@"my_string_param_key"];
    return params0;
}

- (EAOProduct*)createProduct0
{
    EAOProduct *product0 = [[EAOProduct alloc] initWithRef:@"my_product0_ref"];
    [product0 setEulerianWithGroup:@"my_group0"];
    [product0 setEulerianWithName:@"my_name0"];
    [product0 setEulerianWithParams:[self createParams0]];
    return product0;
}

- (EAOProduct*)createProduct1
{
    EAOProduct *product1 = [[EAOProduct alloc] initWithRef:@"my_product1_ref"];
    [product1 setEulerianWithName:@"my_name1"];
    return product1;
}

- (EAOProduct*)createProduct2
{
    EAOProduct *product2 = [[EAOProduct alloc] initWithRef:@"my_product2_ref"];
    [product2 setEulerianWithGroup:@"my_group2"];
    return product2;
}

- (EACart*)createEACart
{
    EACart *cart = [[EACart alloc] initWithPath:@"my_path"];
    [cart setEulerianWithCumul:YES];
    [cart addEulerian:[self createProduct0] amount:99.99 quantity:2];
    [cart addEulerian:[self createProduct1] amount:149.99 quantity:1];
    [cart addEulerian:[self createProduct2] amount:149.99 quantity:1];
    return cart;
}

- (EAEstimate*)createEAEstimate
{
    EAEstimate *estimate = [[EAEstimate alloc] initWithPath:@"my_path" withRef:@"my_ref"];
    [estimate addEulerian:[self createProduct0] amount:9.99 quantity:10];
    [estimate addEulerian:[self createProduct1] amount:49.01 quantity:0];
    [estimate addEulerian:[self createProduct2] amount:49.13 quantity:2];
    [estimate setEulerianWithType:@"my_type"];
    [estimate setEulerianWithCurrency:@"my_currency"];
    [estimate setEulerianWithAmount:1234.56789];
    return estimate;
}

- (EAOrder*)createEAOrder
{
    EAOrder *order = [[EAOrder alloc] initWithPath:@"my_path" withRef:@"my_ref"];
    [order addEulerian:[self createProduct0] amount:9.99 quantity:10];
    [order addEulerian:[self createProduct1] amount:49.01 quantity:0];
    [order addEulerian:[self createProduct2] amount:49.13 quantity:2];
    [order setEulerianWithType:@"my_type"];
    [order setEulerianWithCurrency:@"my_currency"];
    [order setEulerianWithAmount:1234.56789];
    [order setEulerianWithPayment:@"my_payment"];
    [order setEulerianWithEstimateRef:@"my_estimate_ref"];
    return order;
}

- (EASearch*)createEASearch
{
    EASearch *search = [[EASearch alloc] initWithPath:@"my_path" withName:@"my_name"];
    [search setEulerianWithResults:42];
    [search setEulerianWithParams:[self createParams0]];
    return search;
}

@end
