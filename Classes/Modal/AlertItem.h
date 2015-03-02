//
//  AlertItem.h
//  DiningBuddy
//
//  Created by Adam Fendley on 12/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SettingsService;

@interface AlertItem : NSObject

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSString *targetOS;
@property(nonatomic, retain) NSString *targetVersion;
@property(nonatomic) long long targetTimeMin;
@property(nonatomic) long long targetTimeMax;

- (bool)isApplicable;

@end
