//
//  EAnalytics.h
//  EAnalytics
//
//  Created by FRouault on 21/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAProperties.h"

@interface EAnalytics : NSObject {
    
}

+ (void)initWithHost:(NSString *)host andWithDebugLogs:(BOOL) debug;
+ (void)track:(EAProperties *)properties;
+ (NSString*)euidl;
+ (NSString*)version;

@end
