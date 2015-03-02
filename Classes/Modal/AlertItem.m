//
//  AlertItem.m
//  DiningBuddy
//
//  Created by Adam Fendley on 12/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "AlertItem.h"
#import "SettingsService.h"

@implementation AlertItem

- (bool)isApplicable {
    NSString *thisOS = @"iOS";
    NSString *thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    long long thisTime = [SettingsService getTime];

    // Reasons to disqualify this alert:
    if (![self.target_os isEqualToString:@"all"] && ![self.target_os isEqualToString:thisOS]) {
        NSLog(@"Alert disqualified for target: %@, %@", self.target_os, thisOS);
        return false;
    }
    if (![self.target_version isEqualToString:@"all"] && ![self.target_version isEqualToString:thisVersion]) {
        NSLog(@"Alert disqualified for version: %@, %@", self.target_version, thisVersion);
        return false;
    }
    if ((self.target_time_min != 0 && self.target_time_min > thisTime) || (self.target_time_max != 0 && self.target_time_max < thisTime)) {
        NSLog(@"Alert disqualified for time: %lli", thisTime);
        return false;
    }
    return true;
}

@end
