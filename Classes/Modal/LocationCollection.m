//
//  LocationCollection.m
//  DiningBuddy
//
//  Created by Adam Fendley on 3/2/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import "LocationCollection.h"
#import "CoordinatePair.h"

@implementation LocationCollection

@synthesize locations;

- (id)initWithJson:(id)json {
    self = [super init];
    if (self) {;
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSArray *array = json[@"features"];
        for (NSDictionary *value in array) {
            [list addObject:[self deserialize:value]];
        }
        self.locations = [list copy];
    }
    return self;
}

- (LocationItem *)deserialize:(NSDictionary *)value {
    id properties = value[@"properties"];
    id geometry = value[@"geometry"];

    NSString *name = [properties objectForKey:@"name"];
    NSInteger priority = [[properties objectForKey:@"priority"] integerValue];

    NSArray *coordinates = [[geometry objectForKey:@"coordinates"] objectAtIndex:0];
    NSMutableArray *coordinatePairs = [[NSMutableArray alloc] init];
    for (NSArray *coord in coordinates) {
        double longitude = [coord[0] doubleValue];
        double latitude = [coord[1] doubleValue];
        [coordinatePairs addObject:[[CoordinatePair alloc] initWithDouble:latitude withDouble:longitude]];
    }
    return [[LocationItem alloc] initWithName:name withCoordinatePairs:coordinatePairs withPriority:priority];
}

@end
