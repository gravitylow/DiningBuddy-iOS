//
//  Api.h
//  CNU
//
//  Created by Adam Fendley on 10/11/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Location;
@class Locator;
@class BackendService;
@class SettingsService;
@class LocationService;
@class LocationInfo;
@class CoordinatePair;
@class MenuViewController;
@class FeedViewController;
@class LocationMenuItem;
@class LocationFeedItem;
@class AlertItem;

@interface Api : NSObject

extern NSString * const API_HOST;
extern NSString * const API_VERSION;
extern NSString * const API_QUERY;
extern NSString * const API_CONTENT_TYPE;

+(NSString *)getApiUrl;
+(NSString *)getApiUrlForString: (NSString *) value;
+(void)getLocationsForLocator:(Locator *)locator;
+(NSArray *)locationsFromJson: (id)json;
+(void)getInfoForService:(LocationService *)locationService;
+(NSArray *)infoFromJson: (id)json;
+(void)getLatestMenus;
+(void)getMenuForLocation:(NSString *)location forMenuController:(MenuViewController *)controller;
+(void)getFeedForLocation:(NSString *)location forFeedController:(FeedViewController *)controller;
+(void)sendUpdateWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(Location *)location withTime:(long long)time withUUID:(NSString *)uuid;
+(void)sendFeedbackWithTarget:(NSString *)target withLocation:(Location *)location withCrowded:(int)crowded withMinutes:(int)minutes withFeedback:(NSString *)feedback withTime:(long long)time withUUID:(NSString *)uuid;
+(void)showAlerts :(SettingsService *)settings;

@end
