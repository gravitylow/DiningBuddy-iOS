//
//  ViewController.h
//  CNU
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@class AppDelegate;
@class LocationViewController;
@class BannerViewController;
@class Location;
@class LocationInfo;

@interface ViewController : UIViewController

@property (nonatomic, retain) BannerViewController *regattasView;
@property (nonatomic, retain) BannerViewController *commonsView;
@property (nonatomic, retain) BannerViewController *einsteinsView;

@property(nonatomic, retain) LocationInfo  *lastRegattasInfo;
@property(nonatomic, retain) LocationInfo  *lastCommonsInfo;
@property(nonatomic, retain) LocationInfo  *lastEinsteinsInfo;

@property(nonatomic) bool regattasHasBadge;
@property(nonatomic) bool commonsHasBadge;
@property(nonatomic) bool einsteinsHasBadge;

-(void) updateInfoWithRegattas:(LocationInfo *)regattas withCommons:(LocationInfo *)commons withEinsteins:(LocationInfo *)einsteins;
-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location;
@end

