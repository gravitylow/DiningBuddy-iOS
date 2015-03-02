//
//  LocationFeedItem.h
//  CNU
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationFeedItem : NSObject

@property(nonatomic, retain) NSString *message;
@property(nonatomic) int minutes;
@property(nonatomic) int crowded;
@property(nonatomic) long long time;
@property(nonatomic) bool pinned;
@property(nonatomic, retain) NSString *detail;

- (id)initWithMessage:(NSString *)message withMinutes:(int)min withCrowded:(int)crow withTime:(long long)t withPinned:(bool)pin withDetail:(NSString *)det;

@end
