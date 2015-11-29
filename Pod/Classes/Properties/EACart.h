//
//  EACart.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "EAProperties.h"

@interface EACart : EAProperties

- (void)setEulerianWithCumul:(BOOL)value;
- (void)addEulerian:(EAOProduct*)product amount:(double)amout quantity:(int)quantity;

@end
