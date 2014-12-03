//
//  Locator.h
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BackendService;
@class SettingsService;
@class Location;
@class Api;

@interface Locator : NSObject

@property(nonatomic, retain) NSArray *locationsList;
@property(nonatomic, retain) NSString *jsonValue;
@property(nonatomic) bool setup;

- (id) initWithJson: (NSString *) json;
- (Location *) getLocation: (double) latitude : (double) longitude;
- (void) setLocations: (NSString *)value;
- (void) updateLocations;
- (void) postLocation: (double) latitude : (double) longitude : (Location *) location : (NSString *) uuid;
- (NSArray *) getLocations;
- (bool) isSetup;
- (NSString *) jsonValue;

@end
