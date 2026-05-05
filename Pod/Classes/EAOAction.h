//
//  EAOAction.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAOParams.h"

@interface EAOAction : NSObject

@property (readonly) NSMutableDictionary* dictionary;

- (void)setEulerianWithRef:(NSString *) value;

// New API (mirrors Android Action.Builder)
- (void)setEulerianWithName:(NSString *)value;
- (void)setEulerianWithMode:(NSString *)value;
- (void)setEulerianWithLabel:(NSString *)value;
- (void)setEulerianWithParams:(EAOParams *)value;

// Legacy API — kept for backward compatibility, prefer the new methods above.
- (void)setEulerianWithInValue:(NSString *) value     __attribute__((deprecated("Use -setEulerianWithMode: with @\"in\" + -setEulerianWithLabel:")));
- (void)setEulerianWithOutValues:(NSArray *) values   __attribute__((deprecated("Use -setEulerianWithMode: with @\"out\" + -setEulerianWithLabel:")));

- (void)checkConformity;

@end
