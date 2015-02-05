//
//  LocationService.h
//  CNU
//
//  Created by Adam Fendley on 9/14/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class AppDelegate;
@class Locator;
@class Location;
@class SettingsService;
@class Api;

static double lastLatitude;
static double lastLongitude;
static Location *lastLocation;

@interface LocationService : NSObject <CLLocationManagerDelegate>

@property(nonatomic, retain) Locator *locator;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) SettingsService *settingsService;
@property(nonatomic) long long lastPublishedUpdate;
@property(nonatomic) dispatch_source_t timerSource;

- (id)initWithSettings:(SettingsService *)settings;

- (void)setInfo:(NSArray *)info;

- (void)updateInfo;

- (void)requestFullUpdate;

- (void)startUpdatingLocation;

+ (Location *)getLastLocation;

@end
