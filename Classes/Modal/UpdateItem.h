//
//  UpdateItem.h
//  DiningBuddy
//
//  Created by Adam Fendley on 3/2/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONKeyMapper.h>
#import "JSONModel.h"

@interface UpdateItem : JSONModel

@property(nonatomic, retain) NSString *uuid;
@property(nonatomic, retain) NSNumber *lat;
@property(nonatomic, retain) NSNumber *lon;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSNumber *send_time;

@end
