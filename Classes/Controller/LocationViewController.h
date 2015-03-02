//
//  LocationViewController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class BannerViewController;
@class TabsController;
@class InfoItem;
@class LocationItem;

@interface LocationViewController : UIViewController

@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) NSString *photo;
@property(nonatomic, retain) InfoItem *info;
@property(nonatomic, retain) BannerViewController *banner;
@property(nonatomic, retain) TabsController *tabs;

@property(nonatomic) bool hasBadge;

- (void)updateInfoWithRegattas:(InfoItem *)regattas withCommons:(InfoItem *)commons withEinsteins:(InfoItem *)einsteins;

- (void)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(LocationItem *)location;
@end
