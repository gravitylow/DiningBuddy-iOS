//
//  LocationService.m
//  CNU
//
//  Created by Adam Fendley on 9/14/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "LocationService.h"
#import "Locator.h"
#import "Location.h"
#import "SettingsService.h"
#import "Api.h"


#pragma mark - CLLocationManagerDelegate

@implementation LocationService

@synthesize locationManager;
@synthesize locator;
@synthesize hasLocation;
@synthesize lastLatitude;
@synthesize lastLongitude;
@synthesize lastLocation;
@synthesize lastLocationInfo;
@synthesize settingsService;
@synthesize dieFlag;
@synthesize timerSource;

-(id)initWithSettings:(SettingsService *) settings {
    self = [super init];
    if (self) {
        dieFlag = false;
        NSLog(@"Initializing location service");
        settingsService = settings;
        NSString *cache = [settingsService getCachedLocations];
        NSLog(@"Location cache: %@", cache);
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
    // TODO update UI
}

-(void)updateInfo {
    [Api getInfoForService:self];
}

-(void)startUpdatingLocation {
    NSLog(@"startLocationTracking");
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [locationManager startUpdatingLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
    
    //NSLog(@"Entered new Location with the coordinates Latitude: %f Longitude: %f", currentCoordinates.latitude, currentCoordinates.longitude);
    // TODO send location updates
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Unable to start location manager. Error:%@", [error description]);
}

-(bool)hasLocation {
    return hasLocation;
}
-(double)getLastLatitude {
    return lastLatitude;
}
-(double)getLastLongitude {
    return lastLongitude;
}
-(Location *)getLastLocation {
    return lastLocation;
}
-(void) die {
    dieFlag = true;
    [locationManager stopUpdatingLocation];
}
@end
