//
//  BackendService.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/11/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SettingsService;
@class LocationService;
@class API;

static SettingsService *settingsService;
static LocationService *locationService;

@interface BackendService : NSObject

+ (SettingsService *)getSettingsService;

+ (LocationService *)getLocationService;

+ (void)showAlerts;

@end
