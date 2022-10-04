//
//  EAAssertion.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAAssertion.h"

@implementation EAAssertion

+ (void) assertCondition:(BOOL)condition withMessage:(NSString *)message
{
    if (!condition) {
        NSString *reason = [NSString stringWithFormat:@"EULERIAN ANALYTICS : %@",message];
        NSException *exception = [NSException exceptionWithName:@"Eulerian Exception" reason:reason userInfo:nil];
        [exception raise];
    }
}

+ (void) warnCondition:(BOOL)condition withMessage:(NSString *)message
{
    if (!condition) {
        NSString *warning = [NSString stringWithFormat:@"EULERIAN ANALYTICS | %@", message];
        NSLog(@"EULERIAN ANALYTICS : %@", warning);
    }
}

@end
