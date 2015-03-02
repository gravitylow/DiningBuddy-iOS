//
//  Locator.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BackendService;
@class SettingsService;
@class LocationItem;
@class API;

@interface Locator : NSObject

@property(nonatomic, retain) NSArray *locationsList;
@property(nonatomic, retain) NSString *jsonValue;
@property(nonatomic) bool setup;

- (LocationItem *)getLocation:(double)latitude :(double)longitude;

- (void)updateLocations;

- (NSArray *)getLocations;

- (bool)isSetup;

@end
