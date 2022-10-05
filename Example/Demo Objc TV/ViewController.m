//
//  ViewController.m
//  EAnalytics_ExampleTV
//
//  Created by François Rouault on 22/03/2017.
//  Copyright © 2017 François Rouault. All rights reserved.
//

#import "ViewController.h"
#import "EAnalytics/EAnalytics.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButton:(id)sender {
    NSLog(@"Click");
    EAProperties* prop = [[EAProperties alloc] initWithPath:@"Test TV"];
    [EAnalytics track:prop];
}

@end
