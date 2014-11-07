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
@synthesize wifiOnly, firstUserAlert;
@synthesize lastFeedbackRegattas;
@synthesize lastFeedbackCommons;
@synthesize lastFeedbackEinsteins;

-(id) init {
    self = [super init];
    if (self) {
        preferences = [NSUserDefaults standardUserDefaults];
        locations = [preferences stringForKey:@"pref_locations"];
        wifiOnly = [preferences boolForKey:@"pref_wifi_only"];
        firstUserAlert = [preferences boolForKey:@"pref_first_user_alert"];
        lastFeedbackRegattas = [[preferences objectForKey:@"pref_last_feedback_regattas"] longLongValue];
        lastFeedbackCommons = [[preferences objectForKey:@"pref_last_feedback_commons"] longLongValue];
        lastFeedbackEinsteins = [[preferences objectForKey:@"pref_last_feedback_einsteins"] longLongValue];
    }
    return self;
}

+(NSString *) getUUID {
    return [[[NSUUID UUID] UUIDString] lowercaseString];
}

+(long long) getTime {
    return (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
}

-(void) cacheLocations: (NSString *) json {
    [preferences setObject:json forKey:@"pref_locations"];
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
    [preferences setBool:value forKey:@"pref_wifi_only"];
    [preferences synchronize];
    wifiOnly = value;
}

-(bool) getFirstUserAlert {
    return firstUserAlert;
}

-(void) setFirstUserAlert: (bool) value {
    [preferences setBool:value forKey:@"pref_first_user_alert"];
    [preferences synchronize];
    firstUserAlert = value;
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

-(long long) getLastFeedbackRegattas {
    return lastFeedbackRegattas;
}

-(long long) getLastFeedbackCommons {
    return lastFeedbackCommons;
}

-(long long) getLastFeedbackEinsteins {
    return lastFeedbackEinsteins;
}

-(void) setLastFeedbackRegattas: (long long) time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_regattas"];
    [preferences synchronize];
    lastFeedbackRegattas = time;
}

-(void) setLastFeedbackCommons: (long long) time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_commons"];
    [preferences synchronize];
    lastFeedbackCommons = time;
}

-(void) setLastFeedbackEinsteins: (long long) time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_einsteins"];
    [preferences synchronize];
    lastFeedbackEinsteins = time;
}

@end
