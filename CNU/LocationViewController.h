//
//  LocationViewController.h
//  CNU
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class BannerViewController;
@class TabsController;
@class LocationInfo;
@class Location;

@interface LocationViewController : UIViewController

@property(nonatomic, retain) NSString  *location;
@property(nonatomic, retain) NSString  *label;
@property(nonatomic, retain) NSString  *photo;
@property(nonatomic, retain) LocationInfo *info;
@property(nonatomic, retain) IBOutlet UITabBar  *tabBar;
@property(nonatomic, retain) BannerViewController *banner;
@property(nonatomic, retain) TabsController *tabs;

-(void) updateInfoWithRegattas:(LocationInfo *)regattas withCommons:(LocationInfo *)commons withEinsteins:(LocationInfo *)einsteins;
-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location;
@end
