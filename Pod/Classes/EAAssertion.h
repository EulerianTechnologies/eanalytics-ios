//
//  EAAssertion.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAAssertion : NSObject

+ (void) assertCondition:(BOOL)condition withMessage:(NSString *)message;
+ (void) warnCondition:(BOOL)condition withMessage:(NSString *)message;

@end
