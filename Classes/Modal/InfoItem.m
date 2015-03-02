//
//  LocationInfo.m
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "LocationInfo.h"

@implementation LocationInfo

@synthesize location;
@synthesize people;
@synthesize crowdedRating;

+ (NSArray *)getFeedbackList {
    return @[@"Not crowded at all", @"Somewhat crowded", @"Very crowded"];
}

+ (CrowdedRating)getCrowdedRatingForInt:(int)value {
    CrowdedRating rating = NOT_CROWDED;
    if (value == 1) {
        rating = SOMEWHAT_CROWDED;
    } else if (value == 2) {
        rating = CROWDED;
    }
    return rating;
}

+ (UIColor *)getColorForCrowdedRating:(CrowdedRating)value {
    if (value == NOT_CROWDED) {
        return [UIColor colorWithRed:0.165 green:0.69 blue:0.506 alpha:1]; /*#2ab081*/
    } else if (value == SOMEWHAT_CROWDED) {
        return [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:1]; /*#f39c12*/
    } else {
        return [UIColor colorWithRed:0.851 green:0.255 blue:0.188 alpha:1]; /*#d94130*/
    }
}

- (id)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.location = name;
        self.people = 0;
        self.crowdedRating = NOT_CROWDED;
    }
    return self;
}

- (id)initWithName:(NSString *)name
        withPeople:(int)number
 withCrowdedRating:(CrowdedRating)rating {
    if (self = [super init]) {
        self.location = name;
        self.people = number;
        self.crowdedRating = rating;
    }
    return self;
}

- (NSString *)getLocation {
    return location;
}

- (int)getPeople {
    return people;
}

- (CrowdedRating)getCrowdedRating {
    return crowdedRating;
}

@end
