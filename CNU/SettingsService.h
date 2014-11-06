//
//  SettingsService.h
//  CNU
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface SettingsService : NSObject

@property(nonatomic, retain) NSUserDefaults *preferences;
@property(nonatomic, retain) NSString *locations;
@property(nonatomic) bool wifiOnly;
@property(nonatomic) long lastFeedbackRegattas;
@property(nonatomic) long lastFeedbackCommons;
@property(nonatomic) long lastFeedbackEinsteins;

+(NSString *) getUUID;
+(long long) getTime;
-(void) cacheLocations: (NSString *) json;
-(NSString *) getCachedLocations;
-(bool) getWifiOnly;
-(void) setWifiOnly: (bool) value;
-(bool) isWifiConnected;
-(bool) getShouldConnect;
-(long) getLastFeedbackRegattas;
-(long) getLastFeedbackCommons;
-(long) getLastFeedbackEinsteins;
-(void) setLastFeedbackRegattas: (long) time;
-(void) setLastFeedbackCommons: (long) time;
-(void) setLastFeedbackEinsteins: (long) time;
@end
