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

-(bool)isApplicable {
    NSString *thisOS = @"iOS";
    NSString *thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    long long thisTime = [SettingsService getTime];
    
    // Reasons to disqualify this alert:
    if (![self.targetOS isEqualToString:@"all"] && ![self.targetOS isEqualToString:thisOS]) {
        NSLog(@"Alert disqualified for target: %@, %@", self.targetOS, thisOS);
        return false;
    }
    if (![self.targetVersion isEqualToString:@"all"] && ![self.targetVersion isEqualToString:thisVersion]) {
        NSLog(@"Alert disqualified for version: %@, %@", self.targetVersion, thisVersion);
        return false;
    }
    if ((self.targetTimeMin != 0 && self.targetTimeMin > thisTime) || (self.targetTimeMax != 0 && self.targetTimeMax < thisTime)) {
        NSLog(@"Alert disqualified for time: %lli", thisTime);
        return false;
    }
    return true;
}

@end
