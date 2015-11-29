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
	
    [EAnalytics sayHello];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
