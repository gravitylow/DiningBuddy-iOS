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
@synthesize alertsRead;
@synthesize wifiOnly;
@synthesize lastFeedbackRegattas;
@synthesize lastFeedbackCommons;
@synthesize lastFeedbackEinsteins;

-(id) init {
    self = [super init];
    if (self) {
        preferences = [NSUserDefaults standardUserDefaults];
        locations = [preferences stringForKey:@"pref_locations"];
        alertsRead = [NSMutableArray arrayWithArray:[preferences arrayForKey:@"pref_alerts_read"]];
        NSLog(@"Alerts read: %@", alertsRead);
        wifiOnly = [preferences boolForKey:@"pref_wifi_only"];
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
    //NSLog(@"Time: %lli", (long long)([[NSDate date] timeIntervalSince1970] * 1000.0));
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

-(void) setAlertRead: (NSString *) alert {
    [alertsRead addObject:alert];
    [preferences setValue:alertsRead forKey:@"pref_alerts_read"];
    [preferences synchronize];
}

-(bool) isAlertRead: (NSString *)alert {
    return [alertsRead containsObject:alert];
}

@end
