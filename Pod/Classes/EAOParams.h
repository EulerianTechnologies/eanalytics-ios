//
//  EAOParams.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAOParams : NSObject

@property (readonly) NSMutableDictionary* dictionary;

- (void)setEulerianWithStringValue:(NSString*)value forKey:(NSString*) key;
- (void)setEulerianWithIntValue:(int)value forKey:(NSString*) key;

@end
