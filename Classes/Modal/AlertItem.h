//
//  AlertItem.h
//  DiningBuddy
//
//  Created by Adam Fendley on 12/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@class SettingsService;

@interface AlertItem : JSONModel

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSString *target_os;
@property(nonatomic, retain) NSString *target_version;
@property(nonatomic, retain) NSNumber *target_time_min;
@property(nonatomic, retain) NSNumber *target_time_max;

- (bool)isApplicable;

@end
