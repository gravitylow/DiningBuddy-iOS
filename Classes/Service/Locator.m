//
//  Locator.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "Locator.h"
#import "LocationItem.h"
#import "API.h"

@implementation Locator

@synthesize locationsList;
@synthesize setup;

- (id)init {
    if (self = [super init]) {
        locationsList = [NSMutableArray alloc];
        setup = false;
    }
    return self;
}

- (LocationItem *)getLocation:(double)latitude :(double)longitude {
    NSUInteger count = [locationsList count];
    for (int i = 0; i < count; i++) {
        LocationItem *location = locationsList[i];
        if ([location isInsideLocation:latitude :longitude]) {
            return location;
        }
    }
    return nil;
}

- (void)updateLocations {
    [API getLocations:^(NSArray *locations) {
        if ([locations count] == 0) {
            [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateLocations) userInfo:nil repeats:NO];
        } else {
            locationsList = locations;
            setup = true;
        }
    }];
}

- (NSArray *)getLocations {
    return locationsList;
}

- (bool)isSetup {
    return setup;
}

@end
