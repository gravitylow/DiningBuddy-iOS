//
//  SettingsService.m
//  CNU
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "SettingsService.h"
#import "Api.h"
#import "LocationMenuItem.h"

@implementation SettingsService

@synthesize preferences;

- (id)init {
    self = [super init];
    if (self) {
        preferences = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (NSString *)getUUID {
    return [[[NSUUID UUID] UUIDString] lowercaseString];
}

+ (long long)getTime {
    return (long long) ([[NSDate date] timeIntervalSince1970] * 1000.0);
}

- (void)cacheLocations:(NSString *)json {
    [preferences setObject:json forKey:@"pref_locations"];
    [preferences synchronize];
}

- (NSString *)getCachedLocations {
    return [preferences stringForKey:@"pref_locations"];
}

- (bool)getWifiOnly {
    return [preferences boolForKey:@"pref_wifi_only"];
}

- (bool)isWifiConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    return status == ReachableViaWiFi;
}

- (bool)getShouldConnect {
    if ([self getWifiOnly]) {
        return [self isWifiConnected];
    } else {
        return true;
    }
}

- (long long)getLastFeedbackRegattas {
    return [[preferences objectForKey:@"pref_last_feedback_regattas"] longLongValue];
}

- (long long)getLastFeedbackCommons {
    return [[preferences objectForKey:@"pref_last_feedback_commons"] longLongValue];
}

- (long long)getLastFeedbackEinsteins {
    return [[preferences objectForKey:@"pref_last_feedback_einsteins"] longLongValue];
}

- (void)setLastFeedbackRegattas:(long long)time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_regattas"];
    [preferences synchronize];
}

- (void)setLastFeedbackCommons:(long long)time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_commons"];
    [preferences synchronize];
}

- (void)setLastFeedbackEinsteins:(long long)time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_einsteins"];
    [preferences synchronize];
}

- (void)setAlertRead:(NSString *)alert {
    NSMutableArray *alerts = [NSMutableArray arrayWithArray:[preferences arrayForKey:@"pref_alerts_read"]];
    [alerts addObject:alert];
    [preferences setValue:alerts forKey:@"pref_alerts_read"];
    [preferences synchronize];
}

- (bool)isAlertRead:(NSString *)alert {
    return [[preferences arrayForKey:@"pref_alerts_read"] containsObject:alert];
}

- (bool)getNotifyFavorites {
    return [preferences boolForKey:@"pref_notify_favorites"];
}

- (NSString *)getFavorites {
    return [preferences stringForKey:@"pref_favorites"];
}

- (long long)getLastFavoriteFetch {
    return [[preferences objectForKey:@"pref_last_favorite_fetch"] longLongValue];
}

- (void)setLastFavoriteFetch:(long long)time {
    [preferences setValue:@(time) forKey:@"pref_last_favorite_fetch"];
    [preferences synchronize];
}

- (void)setLatestMenus:(NSArray *)regattas :(NSArray *)commons {
    NSArray *favoritesList = [[self getFavorites] componentsSeparatedByString:@","];

    NSMutableString *regattasItems = [[NSMutableString alloc] init];
    NSMutableString *commonsItems = [[NSMutableString alloc] init];

    NSInteger count = 0;

    for (int i = 0; i < [regattas count]; i++) {
        LocationMenuItem *item = (LocationMenuItem *) regattas[i];
        for (int j = 0; j < [favoritesList count]; j++) {
            NSString *fav = [favoritesList[j] lowercaseString];
            NSString *trim = [fav stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([[item.desc lowercaseString] rangeOfString:trim].location != NSNotFound) {
                [regattasItems appendString:[NSString stringWithFormat:@"%@ at %@, ", fav, item.summary]];
                count++;
            }
        }
    }
    for (int i = 0; i < [commons count]; i++) {
        LocationMenuItem *item = (LocationMenuItem *) commons[i];
        for (int j = 0; j < [favoritesList count]; j++) {
            NSString *fav = [favoritesList[j] lowercaseString];
            NSString *trim = [fav stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([[item.desc lowercaseString] rangeOfString:trim].location != NSNotFound) {
                [commonsItems appendString:[NSString stringWithFormat:@"%@ at %@, ", fav, item.summary]];
                count++;
            }
        }
    }
    if (count > 0) {
        NSMutableString *value = [[NSMutableString alloc] init];

        if ([regattasItems length] > 0) {
            regattasItems = [[regattasItems substringToIndex:[regattasItems length] - 2] mutableCopy];
            [value appendString:[NSString stringWithFormat:@"Regattas is serving %@.", regattasItems]];
        }
        if ([commonsItems length] > 0) {
            commonsItems = [[commonsItems substringToIndex:[commonsItems length] - 2] mutableCopy];
            if ([value length] > 0) {
                [value appendString:@" "];
            }
            [value appendString:[NSString stringWithFormat:@"Commons is serving %@.", commonsItems]];
        }
        [self sendNotification:value];
    }
}

- (void)sendNotification:(NSString *)message {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
