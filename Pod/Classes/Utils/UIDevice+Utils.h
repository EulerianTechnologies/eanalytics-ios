//
//  UIDevice+Utils.h
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>
#include <sys/types.h>
#include <sys/sysctl.h>

#define APPLE_TV UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV

@interface UIDevice(Hardware)

- (NSString *) platform;

@end
