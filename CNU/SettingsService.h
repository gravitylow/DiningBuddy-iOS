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
@property(nonatomic) bool firstUserAlert;
@property(nonatomic) long long lastFeedbackRegattas;
@property(nonatomic) long long lastFeedbackCommons;
@property(nonatomic) long long lastFeedbackEinsteins;

+(NSString *) getUUID;
+(long long) getTime;
-(void) cacheLocations: (NSString *) json;
-(NSString *) getCachedLocations;
-(bool) getWifiOnly;
-(void) setWifiOnly: (bool) value;
-(bool) getFirstUserAlert;
-(void) setFirstUserAlert: (bool) value;
-(bool) isWifiConnected;
-(bool) getShouldConnect;
-(long long) getLastFeedbackRegattas;
-(long long) getLastFeedbackCommons;
-(long long) getLastFeedbackEinsteins;
-(void) setLastFeedbackRegattas: (long long) time;
-(void) setLastFeedbackCommons: (long long) time;
-(void) setLastFeedbackEinsteins: (long long) time;
@end
