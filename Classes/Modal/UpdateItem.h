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

@property NSString *uuid;
@property double lat;
@property double lon;
@property NSString *location;
@property long long send_time;

@end
