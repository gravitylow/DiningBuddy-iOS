//
//  Fence.m
//  CNU
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "Fence.h"

@implementation Fence

-(id)init {
    self = [super init];
    return self;
}

-(id)initWithBounds:(double *)effectiveMinLat :(double *)effectiveMaxLat :(double *)effectiveMinLong :(double *)effectiveMaxLong {
    self = [super init];
    if (self) {
        self.effectiveMinLat = effectiveMinLat;
        self.effectiveMaxLat = effectiveMaxLat;
        self.effectiveMinLong = effectiveMinLong;
        self.effectiveMaxLong = effectiveMaxLong;
    }
    return self;
}

-(bool)addBound:(double *)latitude :(double *)longitude {
    if (self.size == 4) {
        return false;
    } else if (self.size == 0) {
        self.effectiveMinLat = latitude;
        self.effectiveMaxLat = latitude;
        self.effectiveMinLong = longitude;
        self.effectiveMaxLong = longitude;
    } else {
        if (*latitude < *self.effectiveMinLat) self.effectiveMinLat = latitude;
        if (*latitude > *self.effectiveMaxLat) self.effectiveMaxLat = latitude;
        if (*longitude < *self.effectiveMinLong) self.effectiveMinLong = longitude;
        if (*longitude > *self.effectiveMaxLong) self.effectiveMaxLong = longitude;
    }
    self.size++;
    return true;
}

-(bool)isInsideFence:(double *)latitude :(double *)longitude {
    if (self.size != 4) {
        return false;
    }
    return *latitude >= *self.effectiveMinLat
    && *latitude <= *self.effectiveMaxLat
    && *longitude >= *self.effectiveMinLong
    && *longitude <= *self.effectiveMaxLong;
}
-(NSString *)jsonValue {
    return [NSString stringWithFormat:@"%@%f, \"maxLat\" : %f, \"minLong\" : %f, \"maxLong\" : %f}", @"{\"minLat\" : ", *self.effectiveMinLat, *self.effectiveMaxLat, *self.effectiveMinLong, *self.effectiveMaxLong];
}

@end
