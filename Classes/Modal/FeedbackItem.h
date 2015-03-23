//
//  FeedbackItem.h
//  DiningBuddy
//
//  Created by Adam Fendley on 3/2/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONKeyMapper.h>
#import "JSONModel.h"

@interface FeedbackItem : JSONModel

@property(nonatomic, retain) NSString *uuid;
@property(nonatomic, retain) NSString *target;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *feedback;
@property(nonatomic, retain) NSNumber *crowded;
@property(nonatomic, retain) NSNumber *minutes;
@property(nonatomic, retain) NSNumber *send_time;

@end
