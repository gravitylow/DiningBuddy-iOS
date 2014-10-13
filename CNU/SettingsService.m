//
//  SettingsService.m
//  CNU
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "SettingsService.h"
#import "Locator.h"
#import "Location.h"
#import "SettingsService.h"
#import "Api.h"

@implementation SettingsService

@synthesize preferences;
@synthesize locations;
@synthesize wifiOnly;
@synthesize lastFeedbackRegattas;
@synthesize lastFeedbackCommons;
@synthesize lastFeedbackEinsteins;

-(id) init {
    self = [super init];
    if (self) {
        preferences = [NSUserDefaults standardUserDefaults];
        locations = [preferences stringForKey:@"pref_locations"];
        wifiOnly = [preferences boolForKey:@"pref_wifi_only"];
        lastFeedbackRegattas = [preferences integerForKey:@"pref_last_feedback_regattas"];
        lastFeedbackCommons = [preferences integerForKey:@"pref_last_feedback_commons"];
        lastFeedbackEinsteins = [preferences integerForKey:@"pref_last_feedback_einsteins"];
    }
    return self;
}

+(NSString *) getUUID {
    return [[[NSUUID UUID] UUIDString] lowercaseString];
}

+(long) getTime {
    return [@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longValue];
}

-(void) cacheLocations: (NSString *) json {
    [preferences setObject:json forKey:@"pref_wifi_only"];
    [preferences synchronize];
    locations = json;
}

-(NSString *) getCachedLocations {
    return locations;
}

-(bool) getWifiOnly {
    return wifiOnly;
}

-(void) setWifiOnly: (bool) value {
    [preferences setBool:wifiOnly forKey:@"pref_wifi_only"];
    [preferences synchronize];
    wifiOnly = value;
}

-(bool) isWifiConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    return status == ReachableViaWiFi;
}

-(bool) getShouldConnect {
    if ([self getWifiOnly]) {
        return [self isWifiConnected];
    } else {
        return true;
    }
}

-(long) getLastFeedbackRegattas {
    return lastFeedbackRegattas;
}

-(long) getLastFeedbackCommons {
    return lastFeedbackCommons;
}

-(long) getLastFeedbackEinsteins {
    return lastFeedbackEinsteins;
}

-(void) setLastFeedbackRegattas: (long) time {
    [preferences setInteger:time forKey:@"pref_last_feedback_regattas"];
    [preferences synchronize];
    lastFeedbackRegattas = time;
}

-(void) setLastFeedbackCommons: (long) time {
    [preferences setInteger:time forKey:@"pref_last_feedback_commons"];
    [preferences synchronize];
    lastFeedbackCommons = time;
}

-(void) setLastFeedbackEinsteins: (long) time {
    [preferences setInteger:time forKey:@"pref_last_feedback_einsteins"];
    [preferences synchronize];
    lastFeedbackEinsteins = time;
}

@end
