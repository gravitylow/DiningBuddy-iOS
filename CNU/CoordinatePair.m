//
//  CoordinatePair.m
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "CoordinatePair.h"

@implementation CoordinatePair

- (id)initWithDouble:(double)lat
         withDouble:(double)lon {
    if (self = [super init]) {
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}

- (double)getLatitude {
    return self.latitude;
}

- (double)getLongitude {
    return self.longitude;
}

- (NSString *)jsonValue {
    return [NSString stringWithFormat:@"%@%f, \"lon\" : %f}", @"{\"lat\" : ", self.latitude, self.longitude];
}

@end
