//
//  UIDevice+Utils.m
//  EAnalytics
//
//  Created by FRouault on 22/11/2015.
//  Copyright © 2015 Eulerian Technologies. All rights reserved.
//

#import "UIDevice+Utils.h"

@implementation UIDevice(Hardware)

- (NSString *) platform{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

@end
