//
//  EASearch.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAProperties.h"

@interface EASearch : EAProperties

- (instancetype)initWithPath:(NSString *)path withName:(NSString*)name;
- (void)setEulerianWithResults:(int)value;
- (void)setEulerianWithParams:(EAOParams*)value;

@end
