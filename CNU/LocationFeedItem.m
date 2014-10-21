//
//  LocationFeedItem.m
//  CNU
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "LocationFeedItem.h"

@implementation LocationFeedItem

-(id) initWithMessage:(NSString *)mess withMinutes:(int)min withCrowded:(int)crow withTime:(long)t withPinned:(bool)pin withDetail:(NSString *)det{
    if (self = [super init]) {
        self.message = mess;
        self.minutes = min;
        self.crowded = crow;
        self.time = t;
        self.pinned = pin;
        self.detail = det;
    }
    return self;
}

@end
