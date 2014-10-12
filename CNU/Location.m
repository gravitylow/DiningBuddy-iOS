//
//  Location.m
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "Location.h"
#import "CoordinatePair.h"

@implementation Location

@synthesize name;
@synthesize coordinatePairs;
@synthesize subLocations;

- (id) init {
    if (self = [super init]) {
        self.coordinatePairs = [NSMutableArray alloc];
        self.subLocations = [NSMutableArray alloc];
    }
    return self;
}
- (id) initWithName:(NSString *)name
withCoordinatePairs:(NSMutableArray *)coordinatePairs {
    if (self = [super init]) {
        self.name = name;
        self.coordinatePairs = coordinatePairs;
        self.subLocations = [NSMutableArray alloc];
    }
    return self;
}
- (id) initWithName:(NSString *)name
withCoordinatePairs:(NSMutableArray *)coordinatePairs
   withSubLocations:(NSMutableArray *)subLocations {
    if (self = [super init]) {
        self.name = name;
        self.coordinatePairs = coordinatePairs;
        self.subLocations = subLocations;
    }
    return self;
}
- (NSString *) getName {
    return name;
}
- (NSArray *) getSubLocations {
    return subLocations;
}
- (bool) hasSubLocations {
    return [subLocations count] > 0;
}
- (bool) isInsideLocation:(double) latitude :(double) longitude {
    double angle = 0;
    double point1lat;
    double point1long;
    double point2lat;
    double point2long;
    NSUInteger n = [coordinatePairs count];
    
    for(int i=0;i<n;i++) {
        CoordinatePair *pair1 = [coordinatePairs objectAtIndex:i];
        CoordinatePair *pair2 = [coordinatePairs objectAtIndex:(i+1)%n];
        point1lat = [pair1 getLatitude] - latitude;
        point1long = [pair1 getLongitude] - longitude;
        point2lat = [pair2 getLatitude] - latitude;
        point2long = [pair2 getLongitude] - longitude;
        angle += [self angle2D:point1lat :point1long :point1lat :point2long];
    }
    
    if (abs(angle) < M_PI) {
        return false;
    } else {
        return true;
    }
}
- (double) angle2D:(double) y1 :(double) x1 :(double) y2 :(double) x2 {
    double dtheta, theta1, theta2;
    theta1 = atan2(y1, x1);
    theta2 = atan2(y2, x2);
    dtheta = theta2 - theta1;
    while (dtheta > M_PI) {
        dtheta -= M_PI * 2;
    }
    while (dtheta < -M_PI) {
        dtheta += M_PI * 2;
    }
    return dtheta;
}
- (NSString *) coordinatePairsJsonValue {
    NSMutableString *value = [NSMutableString alloc];
    [value appendString:@"["];
    NSUInteger count = [coordinatePairs count];
    if (count > 0) {
        for(int i=0;i<count;i++) {
            CoordinatePair *pair = [coordinatePairs objectAtIndex:i];
            [value appendString:[pair jsonValue]];
            [value appendString:@","];
        }
        [value deleteCharactersInRange:NSMakeRange([value length]-1, 1)];
    }
    return value;
}
- (NSString *) subLocationsJsonValue {
    NSMutableString *value = [NSMutableString alloc];
    [value appendString:@"["];
    NSUInteger count = [subLocations count];
    if (count > 0) {
        for(int i=0;i<count;i++) {
            Location *loc = [subLocations objectAtIndex:i];
            [value appendString:[loc jsonValue]];
            [value appendString:@","];
        }
        [value deleteCharactersInRange:NSMakeRange([value length]-1, 1)];
    }
    return value;
}
- (NSString *) jsonValue {
    return [NSString stringWithFormat:@"%@%@\", \"coordinatePairs\" : %@, \"subLocations\" : %@}", @"{\"name\" : \"", name, [self coordinatePairsJsonValue], [self subLocationsJsonValue]];
}

@end
