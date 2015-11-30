//
//  EAnalytics.h
//  EAnalytics
//
//  Created by FRouault on 21/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EAnalytics/EAProperties.h>
#import <EAnalytics/EAOProduct.h>
#import <EAnalytics/EAProducts.h>
#import <EAnalytics/EACart.h>
#import <EAnalytics/EAEstimate.h>
#import <EAnalytics/EAOrder.h>
#import <EAnalytics/EASearch.h>

@interface EAnalytics : NSObject {
    
}

+ (void)initWithHost:(NSString *)host andWithDebugLogs:(BOOL) debug;
+ (void)track:(EAProperties *)properties;
+ (NSString*)euidl;
+ (NSString*)version;

@end
