//
//  ViewController.m
//  EAnalytics
//
//  Created by François Rouault on 11/29/2015.
//  Copyright (c) 2015 François Rouault. All rights reserved.
//

#import "ViewController.h"
#import <EAnalytics/EAnalytics.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [EAnalytics initWithHost:@"dem.eulerian.net" andWithDebugLogs:YES];

    NSLog(@"euidl : %@", [EAnalytics euidl]);
    NSLog(@"EAnalytics version : %@", [EAnalytics version]);

    [self installDemoButtons];
}

- (void)installDemoButtons
{
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 12.0;
    stack.alignment = UIStackViewAlignmentFill;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],
        [stack.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:80]
    ]];

    NSArray<NSDictionary *> *buttons = @[
        @{ @"title": @"PROPERTIES (with action)", @"sel": NSStringFromSelector(@selector(onClickProperties:)) },
        @{ @"title": @"ACTION",                   @"sel": NSStringFromSelector(@selector(onClickAction:)) },
        @{ @"title": @"TP VIEW",                  @"sel": NSStringFromSelector(@selector(onClickTpView:)) },
        @{ @"title": @"TP CLICK",                 @"sel": NSStringFromSelector(@selector(onClickTpClick:)) }
    ];
    for (NSDictionary *def in buttons) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        [b setTitle:def[@"title"] forState:UIControlStateNormal];
        [b addTarget:self action:NSSelectorFromString(def[@"sel"]) forControlEvents:UIControlEventTouchUpInside];
        [stack addArrangedSubview:b];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButton:(id)sender
{
    [EAnalytics track:[self createProperties]];
}

- (EAProperties*)createProperties
{
    EAProperties *prop = [[EAProperties alloc] initWithPath:@"my_prop_path"];
    [prop setEulerianWithEmail:@"test@toto.com"];
    [prop setEulerianWithValue:@"custom_value" forKey:@"custom_key"];
    [prop setEulerianWithLatitude:1.34453 longitude:2.34245325];
    [prop setEulerianWithAction:[self createAction]];
    [prop setEulerianWithProperties:[self createSiteCentric]];
    [prop setEulerianWithCFlag:[self createSiteCentricCFlag]];
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

#pragma mark - Demo handlers (ported from Android)

- (IBAction)onClickProperties:(id)sender
{
    EAProperties *prop = [[EAProperties alloc] initWithPath:@"the_path"];
    [prop setEulerianWithEmail:@"test-email"];
    [prop setEulerianWithPageGroup:@"test-group"];
    [prop setEulerianWithProfile:@"test-profile"];
    [prop setEulerianWithUid:@"test-uid"];
    [prop setEulerianWithValue:@"..." forKey:@"whatever"];

    [prop addEulerianWithAction:[self buildActionWithName:@"test-action-andrea-properties-1"
                                                      ref:@"ref-XXX"
                                                     mode:@"in"
                                                    label:@"lb1,lb2,lb3"
                                                   params:@{ @"provenance": @"martinique", @"couleur": @"jaune" }]];
    [prop addEulerianWithAction:[self buildActionWithName:@"test-action-andrea-properties-2"
                                                      ref:@"test-action-andrea-properties-2"
                                                     mode:@"out"
                                                    label:@"lb4,lb5,lb6"
                                                   params:@{ @"couleur": @"jaune" }]];

    [EAnalytics track:prop];
}

- (IBAction)onClickAction:(id)sender
{
    EAProperties *prop = [[EAProperties alloc] initWithPath:@"the_path"];
    [prop setEulerianStandalone];
    [prop setEulerianWithEmail:@"test-email"];
    [prop setEulerianWithPageGroup:@"test-group"];
    [prop setEulerianWithProfile:@"test-profile"];
    [prop setEulerianWithUid:@"test-uid"];

    [prop addEulerianWithAction:[self buildActionWithName:@"test-action-andrea-1"
                                                      ref:@"ref-XXX"
                                                     mode:@"in"
                                                    label:@"lb1,lb2,lb3"
                                                   params:@{ @"provenance": @"martinique", @"couleur": @"jaune" }]];
    [prop addEulerianWithAction:[self buildActionWithName:@"test-action-andrea-2"
                                                      ref:@"test-action-andrea-2"
                                                     mode:@"out"
                                                    label:@"lb4,lb5,lb6"
                                                   params:@{ @"couleur": @"jaune" }]];

    [EAnalytics track:prop];
}

- (IBAction)onClickTpView:(id)sender
{
    EATpView *view = [[EATpView alloc] initWithPath:@"homepage"];
    [view setSiteName:@"admin-andrea2"];
    [view setCampaign:@"summer_sale"];
    [view setPlacement:@"banner_top"];
    [view addProductWithRef:@"PROD_001" position:@(0)];
    [view addProductWithRef:@"PROD_002" position:@(1)];
    [view setUrl:@"http://eulerian.net"];
    [EAnalytics track:view];
}

- (IBAction)onClickTpClick:(id)sender
{
    EATpClick *click = [[EATpClick alloc] initWithPath:@"homepage"];
    [click setSiteName:@"admin-andrea2"];
    [click setCampaign:@"summer_sale"];
    [click setPlacement:@"banner_top"];
    [click setProductWithRef:@"PROD_001" position:2];
    [click setUrl:@"http://eulerian.net"];
    [EAnalytics track:click];
}

- (EAOAction *)buildActionWithName:(NSString *)name
                               ref:(NSString *)ref
                              mode:(NSString *)mode
                             label:(NSString *)label
                            params:(NSDictionary<NSString *, NSString *> *)params
{
    EAOAction *action = [[EAOAction alloc] init];
    [action setEulerianWithName:name];
    [action setEulerianWithRef:ref];
    [action setEulerianWithMode:mode];
    [action setEulerianWithLabel:label];

    EAOParams *p = [[EAOParams alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *k, NSString *v, BOOL *stop) {
        [p setEulerianWithStringValue:v forKey:k];
    }];
    [action setEulerianWithParams:p];
    return action;
}

- (EAOSiteCentricProperties *)createSiteCentric
{
    EAOSiteCentricProperties *siteCentric = [[EAOSiteCentricProperties alloc] init];
    [siteCentric setEulerianWithValues:@[@"my_value_site_centric_0", @"my_value_site_centric_1"] forKey:@"my_key_site_centric"];
    return siteCentric;
}

- (EAOSiteCentricCFlag *)createSiteCentricCFlag
{
    EAOSiteCentricCFlag *siteCentric = [[EAOSiteCentricCFlag alloc] init];
    [siteCentric setEulerianWithValues:@[@"rolandgarros", @"wimbledon"] forKey:@"category_1"];
    [siteCentric setEulerianWithValues:@[@"tennis"] forKey:@"category_2"];
    [siteCentric setEulerianWithValues:@[@"us open"] forKey:@"category_3"];
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
