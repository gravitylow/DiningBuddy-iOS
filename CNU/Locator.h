//
//  Locator.h
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;
@class Api;

@interface Locator : NSObject

@property(nonatomic, retain) NSArray *locations;
@property(nonatomic) bool setup;

- (id) init;
- (id) initWithJson: (NSString *) json;
- (Location *) getLocation: (double) latitude : (double) longitude;
- (Location *) getApplicableLocation: (Location *) base : (double) latitude : (double) longitude;
- (void) setLocations: (NSArray *)array;
- (void) updateLocations;
- (void) postLocation: (double) latitude : (double) longitude : (Location *) location : (NSString *) uuid;
- (NSArray *) getLocations;
- (NSArray *) getAllLocations;
- (NSArray *) recursiveGetLocations: (NSMutableArray *) build : (NSArray *) locs;
- (bool) isSetup;
- (NSString *) jsonValue;

@end
