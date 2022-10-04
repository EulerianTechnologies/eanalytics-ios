//
//  EAnalytics.h
//  EAnalytics
//
//  Created by FRouault on 21/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AdIdentifier.h"
#import "EAAssertion.h"
#import "EACart.h"
#import "EAEstimate.h"
#import "EAOAction.h"
#import "EAOParams.h"
#import "EAOProduct.h"
#import "EAOSiteCentricCFlag.h"
#import "EAOSiteCentricProperties.h"
#import "EAOrder.h"
#import "EAProducts.h"
#import "EAProperties.h"
#import "EASearch.h"

@interface EAnalytics : NSObject {
    
}

+ (void)initWithHost:(NSString *)host andWithDebugLogs:(BOOL) debug;
+ (void)track:(EAProperties *)properties;
+ (NSString*)euidl;
+ (NSString*)version;

@end
