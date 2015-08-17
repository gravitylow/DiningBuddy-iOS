//
//  CoordinatePair.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "CoordinatePair.h"

@implementation CoordinatePair

- (id)initWithDouble:(double)lat
          withDouble:(double)lon {
    if (self = [super init]) {
        self.latitude = [NSNumber numberWithDouble:lat];
        self.longitude = [NSNumber numberWithDouble:lon];
    }
    return self;
}

- (double)getLatitude {
    return [self.latitude doubleValue];
}

- (double)getLongitude {
    return [self.longitude doubleValue];
}

- (NSString *)jsonValue {
    return [NSString stringWithFormat:@"{\"lat\" %@, \"lon\" : %@}", self.latitude, self.longitude];
}

@end
