//
//  TabsController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoItem;
@class FeedbackViewController;
@class GraphViewController;
@class BackendService;
@class LocationService;
@class SettingsService;
@class LocationItem;
@class MenuViewController;
@class CombinedFeedViewController;
@class FeedViewController;

extern int const TAB_LOCATION_FEED;
extern int const TAB_LOCATION_MENU;
extern int const TAB_LOCATION_HOURS;
extern int const TAB_LOCATION_GRAPH;

@interface TabsController : UITabBarController <UITabBarDelegate>

@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) InfoItem *info;

@property(nonatomic, retain) id feedbackTabItem;

- (void)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(LocationItem *)location;

@end
