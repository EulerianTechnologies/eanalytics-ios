//
//  EAOSiteCentricCFlag.h
//  Pods
//
//  Created by François Rouault on 07/09/2017.
//
//

#import <Foundation/Foundation.h>

@interface EAOSiteCentricCFlag : NSObject

@property (readonly) NSMutableDictionary* dictionary;

- (void)setEulerianWithValues:(NSArray *)values forKey:(NSString *)key;

@end
