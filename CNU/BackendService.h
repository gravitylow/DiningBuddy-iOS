//
//  BackendService.h
//  CNU
//
//  Created by Adam Fendley on 10/11/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SettingsService;
@class LocationService;

@interface BackendService : NSObject

@property (nonatomic, retain) SettingsService *settingsService;
@property (nonatomic, retain) LocationService *locationService;

-(SettingsService *) getSettingsService;
-(LocationService *) getLocationService;

@end
