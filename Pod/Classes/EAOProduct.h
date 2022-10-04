//
//  EAOProduct.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAOParams.h"

@interface EAOProduct : NSObject

@property (readonly) NSMutableDictionary* dictionary;

- (instancetype)initWithRef:(NSString*)ref;

- (void)setEulerianWithName:(NSString*)value;
- (void)setEulerianWithGroup:(NSString*)value;
- (void)setEulerianWithParams:(EAOParams*)value;

@end
