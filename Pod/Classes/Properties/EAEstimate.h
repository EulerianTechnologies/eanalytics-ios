//
//  EAEstimate.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAProperties.h"

@interface EAEstimate : EAProperties

- (instancetype)initWithPath:(NSString *)path withRef:(NSString*)ref;
- (void)setEulerianWithAmount:(double)value;
- (void)setEulerianWithCurrency:(NSString*)value;
- (void)setEulerianWithType:(NSString*)value;
- (void)addEulerian:(EAOProduct*)product amount:(double)amout quantity:(int)quantity;

@end
