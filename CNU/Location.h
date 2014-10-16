//
//  Location.h
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoordinatePair;

@interface Location : NSObject

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSArray *coordinatePairs;
@property(nonatomic, retain) NSArray *subLocations;

- (id) init;
- (id) initWithName:(NSString *)nameValue
            withCoordinatePairs:(NSArray *)coordinatePairsValue;
- (id) initWithName:(NSString *)nameValue
            withCoordinatePairs:(NSArray *)coordinatePairsValue
            withSubLocations:(NSArray *)subLocationsValue;
- (NSString *) getName;
- (NSArray *) getSubLocations;
- (bool) hasSubLocations;
- (bool) isInsideLocation:(double) latitude :(double) longitude;
- (double) angle2D:(double) y1 :(double) x1 :(double) y2 :(double) x2;
- (NSString *) coordinatePairsJsonValue;
- (NSString *) subLocationsJsonValue;
- (NSString *) jsonValue;


@end
