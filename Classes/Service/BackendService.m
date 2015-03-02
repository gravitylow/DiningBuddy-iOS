//
//  BackendService.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/11/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "BackendService.h"
#import "SettingsService.h"
#import "LocationService.h"
#import "API.h"
#import "AlertItem.h"

@implementation BackendService

- (id)init {
    self = [super init];
    if (self) {
        settingsService = [[SettingsService alloc] init];
        NSLog(@"Device UUID: %@", [SettingsService getUUID]);
        NSLog(@"Wifi Only: %i", [settingsService getWifiOnly]);
        NSLog(@"Wifi Connected: %i", [settingsService isWifiConnected]);
        NSLog(@"Should connect: %i", [settingsService getShouldConnect]);

        locationService = [[LocationService alloc] initWithSettings:settingsService];
        [locationService startUpdatingLocation];
    }
    return self;
}

+ (SettingsService *)getSettingsService {
    return settingsService;
}

+ (LocationService *)getLocationService {
    return locationService;
}

+ (void)showAlerts {
    [API getAlerts:^(NSArray *alerts) {
        if ([alerts count] > 0) {
            for (AlertItem *item in alerts) {
                if ([item isApplicable] && ![settingsService isAlertRead:item.message]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item.title
                                                                    message:item.message
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [settingsService setAlertRead:item.message];
                }
            }
        }
    }];
}
@end
