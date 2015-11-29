//
//  EAOAction.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAOAction : NSObject

@property (readonly) NSMutableDictionary* dictionary;

- (void) setEulerianWithRef:(NSString *) value;
- (void) setEulerianWithInValue:(NSString *) value;
- (void) setEulerianWithOutValues:(NSArray *) values;
- (void) checkConformity;

@end
