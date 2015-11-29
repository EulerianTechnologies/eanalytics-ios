//
//  EAProperties.h
//  EAnalytics
//
//  Created by FRouault on 21/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAOAction.h"
#import "EAOSiteCentricProperties.h"
#import "EAOProduct.h"
#import <CoreLocation/CoreLocation.h>

@interface EAProperties : NSObject

@property (readonly) NSMutableDictionary* dictionary;

- (NSString *) json;

- (id) initWithPath:(NSString*) path;
- (void) setEulerianWithLatitude:(double)latitude longitude:(double)longitude;
- (void) setEulerianWithLocation:(CLLocationCoordinate2D) location;
- (void) setEulerianWithEmail:(NSString*)value;
- (void) setEulerianWithUid:(NSString*)value;
- (void) setEulerianWithProfile:(NSString*)value;
- (void) setEulerianWithPageGroup:(NSString*)value;
- (void) setEulerianWithNewCustomer:(BOOL)value;
- (void) setEulerianWithAction:(EAOAction*)value;
- (void) setEulerianWithProperties:(EAOSiteCentricProperties*)value;
- (void) setEulerianWithValue:(id)value forKey:(NSString *)key;

@end
