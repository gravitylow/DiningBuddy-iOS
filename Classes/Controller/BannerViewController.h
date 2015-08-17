//
//  BannerViewController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKCardView.h"

@class LocationItem;
@class InfoItem;

@interface BannerViewController : UIViewController

@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) NSString *photo;
@property(nonatomic, retain) InfoItem *info;
@property(nonatomic, retain) RKCardView *cardView;

- (void)updateInfoWithRegattas:(InfoItem *)regattas withCommons:(InfoItem *)commons withEinsteins:(InfoItem *)einsteins;

- (void)updateViewWithLocationInfo:(InfoItem *)locationInfo;

- (bool)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(LocationItem *)location;
@end
