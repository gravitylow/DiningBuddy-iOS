//
//  LocationCollection.m
//  DiningBuddy
//
//  Created by Adam Fendley on 3/2/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import "LocationCollection.h"
#import "LocationItem.h"
#import "CoordinatePair.h"

@implementation LocationCollection

@synthesize locations;

- (id) initWithString: (NSString *) string {
    self = [super init];
    if (self) {
        NSDictionary *dictionary = (NSDictionary *) string;
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSArray *array = [dictionary objectForKey:@"features"];
        for (NSDictionary *value in array) {
            [list addObject:[self deserialize:value]];
        }
        self.locations = [list copy];
    }
    return self;
}

- (LocationItem *) deserialize: (NSDictionary *) value {
    id properties = [value objectForKey:@"properties"];
    id geometry = [value objectForKey:@"geometry"];
    
    NSString *name = [properties objectForKey:@"name"];
    NSInteger priority = [[properties objectForKey:@"priority"] integerValue];
    
    NSArray *coordinates = [[geometry objectForKey:@"coordinates"] objectAtIndex:0];
    NSMutableArray *coordinatePairs = [[NSMutableArray alloc] init];
    for (NSArray *value in coordinates) {
        double longitude = [value[0] doubleValue];
        double latitude = [value[1] doubleValue];
        [coordinatePairs addObject:[[CoordinatePair alloc] initWithDouble:latitude withDouble:longitude]];
    }
    return [[LocationItem alloc] initWithName:name withCoordinatePairs:coordinatePairs withPriority:priority];
}

@end
