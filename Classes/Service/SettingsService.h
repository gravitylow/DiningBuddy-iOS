//
//  SettingsService.h
//  CNU
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@class LocationMenuItem;

@interface SettingsService : NSObject

@property(nonatomic, retain) NSUserDefaults *preferences;

+ (NSString *)getUUID;

+ (long long)getTime;

- (void)cacheLocations:(NSString *)json;

- (NSString *)getCachedLocations;

- (bool)getWifiOnly;

- (bool)isWifiConnected;

- (bool)getShouldConnect;

- (long long)getLastFeedbackRegattas;

- (long long)getLastFeedbackCommons;

- (long long)getLastFeedbackEinsteins;

- (void)setLastFeedbackRegattas:(long long)time;

- (void)setLastFeedbackCommons:(long long)time;

- (void)setLastFeedbackEinsteins:(long long)time;

- (long long)getLastFavoriteFetch;

- (void)setLastFavoriteFetch:(long long)time;

- (void)setAlertRead:(NSString *)alert;

- (bool)isAlertRead:(NSString *)alert;

- (bool)getNotifyFavorites;

- (NSString *)getFavorites;

- (void)setLatestMenus:(NSArray *)regattas :(NSArray *)commons;
@end