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

@property(nonatomic, retain) NSString *uuid;
@property(nonatomic, retain) NSString *feedback;
@property(nonatomic, retain) NSString *detail;
@property(nonatomic, retain) NSString *target;
@property(nonatomic, retain) NSNumber *minutes;
@property(nonatomic, retain) NSNumber *crowded;
@property(nonatomic, retain) NSNumber *time;
@property(nonatomic, retain) NSNumber *send_time;
@property(nonatomic, retain) NSNumber *pinned;

-(BOOL)isPinned;

@end
