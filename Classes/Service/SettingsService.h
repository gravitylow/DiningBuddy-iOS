//
//  SettingsService.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

extern const long long MIN_FEEDBACK_INTERVAL;

@class MenuItem;

@interface SettingsService : NSObject

@property(nonatomic, retain) NSUserDefaults *preferences;

+ (NSString *)getUUID;

+ (long long)getTime;

- (bool)getWifiOnly;

- (bool)isWifiConnected;

- (bool)getShouldConnect;

- (long long)getLastFeedbackRegattas;

- (long long)getLastFeedbackCommons;

- (long long)getLastFeedbackEinsteins;

- (long long)getLastFeedbackWithLocationName:(NSString *)location;

- (void)setLastFeedbackRegattas:(long long)time;

- (void)setLastFeedbackCommons:(long long)time;

- (void)setLastFeedbackEinsteins:(long long)time;

- (void)setLastFeedbackWithLocationName:(NSString *)location :(long long)time;

- (long long)getLastFavoriteFetch;

- (void)setLastFavoriteFetch:(long long)time;

- (void)setAlertRead:(NSString *)alert;

- (bool)isAlertRead:(NSString *)alert;

- (bool)getNotifyFavorites;

- (NSString *)getFavorites;

- (void)fetchLatestMenus;
@end
