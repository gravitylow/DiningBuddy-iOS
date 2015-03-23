//
//  LocationFeedItem.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface FeedItem : JSONModel

@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSNumber *minutes;
@property(nonatomic, retain) NSNumber *crowded;
@property(nonatomic, retain) NSNumber *time;
@property(nonatomic, retain) NSNumber *pinned;
@property(nonatomic, retain) NSString *detail;

- (id)initWithMessage:(NSString *)message withMinutes:(int)min withCrowded:(int)crow withTime:(long long)t withPinned:(bool)pin withDetail:(NSString *)det;

@end
