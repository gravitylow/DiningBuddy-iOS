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

@property NSString *uuid;
@property NSString *target;
@property NSString *location;
@property NSString *message;
@property int crowded;
@property int minutes;
@property long long send_time;

@end
