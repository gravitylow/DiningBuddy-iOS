//
//  LocationMenuItem.m
//  CNU
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "LocationMenuItem.h"

@implementation LocationMenuItem

- (id)initWithStart:(NSString *)start withEnd:(NSString *)end withSummary:(NSString *)sum withDescription:(NSString *)des {
    if (self = [super init]) {
        self.startTime = start;
        self.endTime = end;
        self.summary = sum;
        self.desc = des;
    }
    return self;
}

@end
