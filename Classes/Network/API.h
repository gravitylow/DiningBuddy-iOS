//
//  API.h
//  DiningBuddy
//
//  Created by Adam Fendley on 3/2/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlertItem;
@class InfoItem;
@class LocationItem;
@class UpdateItem;
@class FeedbackItem;

@interface API : NSObject

+ (void) getAlerts:(void (^)(NSArray *alerts))finishBlock;

+ (void) getLocations:(void (^)(NSArray *locations))finishBlock;

+ (void) getInfo:(void (^)(NSArray *info))finishBlock;

+ (void) getInfoForLocationName: (NSString *) location :(void (^)(InfoItem *info))finishBlock;

+ (void) getMenuForLocationName: (NSString *) location :(void (^)(NSArray *menu))finishBlock;

+ (void) getAllMenus: (void (^)(NSArray *regattas, NSArray *commons))finishBlock;

+ (void) getFeedForLocationName: (NSString *) location :(void (^)(NSArray *feed))finishBlock;

+ (void) sendUpdate: (UpdateItem *) update;

+ (void) sendFeedback: (FeedbackItem *) feedback;

@end
