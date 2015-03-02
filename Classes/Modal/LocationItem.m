//
//  Location.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "LocationItem.h"
#import "CoordinatePair.h"

@implementation LocationItem

@synthesize name;
@synthesize coordinatePairs;

- (id)init {
    if (self = [super init]) {
        self.coordinatePairs = [NSArray alloc];
    }
    return self;
}

- (id) initWithName:(NSString *)nameValue
withCoordinatePairs:(NSArray *)coordinatePairsValue
       withPriority:(NSInteger)priorityValue {
    if (self = [super init]) {
        self.name = nameValue;
        self.coordinatePairs = coordinatePairsValue;
        self.priority = priorityValue;
    }
    return self;
}

- (NSString *)getName {
    return name;
}

- (bool)isInsideLocation:(double)latitude :(double)longitude {
    double angle = 0;
    double point1lat;
    double point1long;
    double point2lat;
    double point2long;
    NSUInteger n = [coordinatePairs count];

    for (int i = 0; i < n; i++) {
        CoordinatePair *pair1 = coordinatePairs[i];
        CoordinatePair *pair2 = coordinatePairs[(i + 1) % n];
        point1lat = [pair1 getLatitude] - latitude;
        point1long = [pair1 getLongitude] - longitude;
        point2lat = [pair2 getLatitude] - latitude;
        point2long = [pair2 getLongitude] - longitude;

        angle += [self angle2D:point1lat :point1long :point2lat :point2long];
    }

    if (abs(angle) < M_PI) {
        return false;
    } else {
        return true;
    }
}

- (double)angle2D:(double)y1 :(double)x1 :(double)y2 :(double)x2 {
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

@end
