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
#import <MessageUI/MessageUI.h>
#import "IASKAppSettingsViewController.h"
#import "IASKSettingsReader.h"

@class AppDelegate;
@class LocationViewController;
@class BannerViewController;
@class Location;
@class LocationInfo;
@class BackendService;
@class LocationService;
@class SettingsService;
@class Api;

@interface ViewController : UIViewController <IASKSettingsDelegate> {
    IASKAppSettingsViewController *appSettingsViewController;
}

@property(nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;

@property(nonatomic, retain) BannerViewController *regattasView;
@property(nonatomic, retain) BannerViewController *commonsView;
@property(nonatomic, retain) BannerViewController *einsteinsView;

@property(nonatomic, retain) LocationInfo *lastRegattasInfo;
@property(nonatomic, retain) LocationInfo *lastCommonsInfo;
@property(nonatomic, retain) LocationInfo *lastEinsteinsInfo;

@property(nonatomic) bool regattasHasBadge;
@property(nonatomic) bool commonsHasBadge;
@property(nonatomic) bool einsteinsHasBadge;

@property(nonatomic, retain) UIRefreshControl *refreshControl;

@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) IBOutlet UIButton *settingsButton;

- (void)refresh;

- (void)updateInfoWithRegattas:(LocationInfo *)regattas withCommons:(LocationInfo *)commons withEinsteins:(LocationInfo *)einsteins;

- (void)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(Location *)location;

- (IBAction)openSettings;

- (void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end

