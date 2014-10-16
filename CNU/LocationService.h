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

@interface LocationService : NSObject <CLLocationManagerDelegate>

extern long const MIN_LOCAL_UPDATE;
extern long const MIN_UPDATE;

@property (nonatomic) double lastLatitude;
@property (nonatomic) double lastLongitude;
@property (nonatomic) bool hasLocation;
@property (nonatomic, retain) Locator *locator;
@property (nonatomic, retain) Location *lastLocation;
@property (nonatomic, retain) NSArray *lastLocationInfo;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) SettingsService *settingsService;
@property (nonatomic) bool dieFlag;
@property (nonatomic) long lastUpdate;
@property (nonatomic) long lastPublishedUpdate;
@property (nonatomic) dispatch_source_t timerSource;

-(id)initWithSettings:(SettingsService *) settings;
-(void)setInfo:(NSArray *) info;
-(void)updateInfo;
-(void)startUpdatingLocation;
-(double) getLastLatitude;
-(double) getLastLongitude;
-(Location *)getLastLocation;
-(bool)hasLocation;
-(void)die;

@end
