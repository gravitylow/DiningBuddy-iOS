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



+ (NSString *) getTextForCrowdedRating: (CrowdedRating) rating {
    if (rating == NOT_CROWDED) {
        return @"Not crowded at all";
    } else if (rating == SOMEWHAT_CROWDED) {
        return @"Somewhat crowded";
    } else if (rating == CROWDED) {
        return @"Very crowded";
    } else {
        return nil;
    }
}

+ (NSArray *) getFeedbackList {
    NSMutableArray *array = [NSMutableArray alloc];
    [array addObject:@"Not crowded at all"];
    [array addObject:@"Somewhat crowded"];
    [array addObject:@"Very crowded"];
    return array;
}

+ (CrowdedRating) getCrowdedRatingForInt: (int) value {
    CrowdedRating rating = NOT_CROWDED;
    if (value == 1) {
        rating = SOMEWHAT_CROWDED;
    } else if (value == 2) {
        rating = CROWDED;
    }
    return rating;
}
- (id) initWithName:(NSString *)name
         withPeople:(int)number
  withCrowdedRating:(CrowdedRating)rating {
    if (self = [super init]) {
        location = name;
        self.people = people;
        self.crowdedRating = rating;
    }
    return self;
}

- (NSString *) getLocation {
    return location;
}
- (int) getPeople {
    return people;
}
- (CrowdedRating) getCrowdedRating {
    return crowdedRating;
}

@end
