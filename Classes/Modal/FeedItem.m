//
//  LocationFeedItem.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

- (id)initWithMessage:(NSString *)mess withMinutes:(int)min withCrowded:(int)crow withTime:(long long)t withPinned:(bool)pin withDetail:(NSString *)det {
    if (self = [super init]) {
        self.message = mess;
        self.minutes = [NSNumber numberWithInt:min];
        self.crowded = [NSNumber numberWithInt:crow];
        self.time = [NSNumber numberWithLongLong:t];
        self.pinned = [NSNumber numberWithBool:pin];
        self.detail = det;
    }
    return self;
}

@end
