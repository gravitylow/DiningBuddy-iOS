//
//  LocationService.m
//  CNU
//
//  Created by Adam Fendley on 9/14/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationService.h"
#import "Locator.h"
#import "Location.h"
#import "SettingsService.h"
#import "Api.h"

#pragma mark - CLLocationManagerDelegate

@implementation LocationService

long const MIN_LOCAL_UPDATE = 5 * 1000;
long const MIN_UPDATE = 60 * 1000;

@synthesize locationManager, locator;
@synthesize lastLocationInfo;
@synthesize settingsService;
@synthesize timerSource, dieFlag;
@synthesize lastPublishedUpdate, lastUpdate;

-(id)initWithSettings:(SettingsService *) settings {
    self = [super init];
    if (self) {
        dieFlag = false;
        settingsService = settings;
        NSString *cache = [settingsService getCachedLocations];
        if (cache) {
            locator = [[Locator alloc] initWithJson:cache];
            NSLog(@"Setup from cache");
        } else {
            locator = [[Locator alloc] init];
            NSLog(@"No cache; awaiting connection to server");
        }
        if ([settingsService getShouldConnect]) {
            [locator updateLocations];
        }
        dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, backgroundQueue);
        dispatch_source_set_timer(timerSource, dispatch_time(DISPATCH_TIME_NOW, 0), 60.0*NSEC_PER_SEC, 0*NSEC_PER_SEC);
        dispatch_source_set_event_handler(timerSource, ^{
            if (dieFlag) {
                dispatch_source_cancel(timerSource);
            } else {
                [self updateInfo];
            }
        });
        dispatch_resume(timerSource);

    }
    return self;
}

-(void)setInfo: (NSArray *) info {
    lastLocationInfo = info;
    NSLog(@"Info: %@", info);
    [AppDelegate updateInfo:info];
}

-(void)updateInfo {
    [Api getInfoForService:self];
}

-(void)startUpdatingLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * currentLocation = (CLLocation *)[locations lastObject];
    
    if (![locator isSetup] || ![settingsService getShouldConnect]) {
        return;
    }
    
    long long currentTime = [SettingsService getTime];
    
    if (lastUpdate != 0 && (currentTime - lastUpdate) < MIN_LOCAL_UPDATE) {
        return;
    }
    
    lastUpdate = currentTime;
    
    CLLocationCoordinate2D currentCoordinates = currentLocation.coordinate;

    hasLocation = true;
    lastLatitude = currentCoordinates.latitude;
    lastLongitude = currentCoordinates.longitude;
    Location *location = [locator getLocation:currentCoordinates.latitude :currentCoordinates.longitude];
    //location.name = @"Einsteins";
    lastLocation = location;
    
    NSLog(@"Location update pushed to AppDelegate");
    
    [AppDelegate updateLocationWithLatitude:currentCoordinates.latitude withLongitude:currentCoordinates.longitude withLocation:location];
    
    if (lastPublishedUpdate == 0 || (currentTime - lastPublishedUpdate) >= MIN_UPDATE) {
        [Api sendUpdateWithLatitude:lastLatitude withLongitude:lastLongitude withLocation:lastLocation withTime:currentTime withUUID:[SettingsService getUUID]];
        lastPublishedUpdate = currentTime;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Unable to start location manager. Error:%@", [error description]);
}

+(bool)hasLocation {
    return hasLocation;
}
+(double)getLastLatitude {
    return lastLatitude;
}
+(double)getLastLongitude {
    return lastLongitude;
}
+(Location *)getLastLocation {
    return lastLocation;
}
-(void) die {
    dieFlag = true;
    [locationManager stopUpdatingLocation];
}
@end
