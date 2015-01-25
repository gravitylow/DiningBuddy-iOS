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
#import "LocationMenuItem.h"

@implementation SettingsService

@synthesize preferences;

-(id) init {
    self = [super init];
    if (self) {
        preferences = [NSUserDefaults standardUserDefaults];
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
}

-(NSString *) getCachedLocations {
    return [preferences stringForKey:@"pref_locations"];
}

-(bool) getWifiOnly {
    return [preferences boolForKey:@"pref_wifi_only"];
}

-(void) setWifiOnly: (bool) value {
    [preferences setBool:value forKey:@"pref_wifi_only"];
    [preferences synchronize];
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
    return [[preferences objectForKey:@"pref_last_feedback_regattas"] longLongValue];
}

-(long long) getLastFeedbackCommons {
    return [[preferences objectForKey:@"pref_last_feedback_commons"] longLongValue];
}

-(long long) getLastFeedbackEinsteins {
    return [[preferences objectForKey:@"pref_last_feedback_einsteins"] longLongValue];
}

-(void) setLastFeedbackRegattas: (long long) time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_regattas"];
    [preferences synchronize];
}

-(void) setLastFeedbackCommons: (long long) time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_commons"];
    [preferences synchronize];
}

-(void) setLastFeedbackEinsteins: (long long) time {
    [preferences setValue:@(time) forKey:@"pref_last_feedback_einsteins"];
    [preferences synchronize];
}

-(void) setAlertRead: (NSString *) alert {
    NSMutableArray *alerts = [NSMutableArray arrayWithArray:[preferences arrayForKey:@"pref_alerts_read"]];
    [alerts addObject:alert];
    [preferences setValue:alerts forKey:@"pref_alerts_read"];
    [preferences synchronize];
}

-(bool) isAlertRead: (NSString *)alert {
    return [[preferences arrayForKey:@"pref_alerts_read"] containsObject:alert];
}

-(bool) getNotifyFavorites {
    return [preferences boolForKey:@"pref_notify_favorites"];
}
-(void) setNotifyFavorites:(bool)value {
    [preferences setBool:value forKey:@"pref_notify_favorites"];
    [preferences synchronize];
}
-(NSString *)getFavorites {
    return [preferences stringForKey:@"pref_favorites"];
}
-(void) setFavorites:(NSString *)value {
    [preferences setValue:value forKey:@"pref_favorites"];
    [preferences synchronize];
}
-(long long) getLastFavoriteFetch {
    return [[preferences objectForKey:@"pref_last_favorite_fetch"] longLongValue];
}
-(void) setLastFavoriteFetch: (long long) time {
    [preferences setValue:@(time) forKey:@"pref_last_favorite_fetch"];
    [preferences synchronize];
}
-(void)setLatestMenus:(NSArray *)regattas :(NSArray *)commons {
    NSInteger count = 0;
    NSMutableString *items = [[NSMutableString alloc] init];
    NSArray *f = [[self getFavorites] componentsSeparatedByString:@","];
    for (int i=0;i<[regattas count];i++) {
        LocationMenuItem *item = (LocationMenuItem *)[regattas objectAtIndex:i];
        for (int j=0;j<[f count];j++) {
            NSString *fav = [[f objectAtIndex:j] lowercaseString];
            if ([[item.desc lowercaseString] containsString:fav]) {
                [items appendString:[NSString stringWithFormat:@"%@, ", fav]];
                count++;
            }
        }
    }
    NSInteger rCount = count;
    if (count != 0) {
        items = [[items substringToIndex:[items length]- 2] mutableCopy];
        [items appendString:@" is being served at Regattas, "];
    }
    for (int i=0;i<[commons count];i++) {
        LocationMenuItem *item = (LocationMenuItem *)[commons objectAtIndex:i];
        for (int j=0;j<[f count];j++) {
            NSString *fav = [[f objectAtIndex:j] lowercaseString];
            if ([[item.desc lowercaseString] containsString:fav]) {
                [items appendString:[NSString stringWithFormat:@"%@, ", fav]];
                count++;
            }
        }
    }
    items = [[items substringToIndex:[items length]- 2] mutableCopy];
    if (count != rCount) {
        [items appendString:@" is being served at Commons"];
    }
    if (count != 0) {
        NSString *list = [items stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[items substringToIndex:1] capitalizedString]];
        [self sendNotification:list];
    }
}
-(void)sendNotification:(NSString *)message {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
