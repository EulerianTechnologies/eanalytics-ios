//
//  EAOSiteCentricProperties.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAOSiteCentricProperties : NSObject

@property (readonly) NSMutableDictionary* dictionary;

- (void)setEulerianWithValues:(NSArray *)values forKey:(NSString *)key;

@end
