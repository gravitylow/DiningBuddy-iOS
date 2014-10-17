//
//  BannerViewController.h
//  CNU
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationInfo;

@interface BannerViewController : UIViewController

@property(nonatomic, retain) NSString  *location;
@property(nonatomic, retain) NSString  *label;
@property(nonatomic, retain) NSString  *photo;
@property(nonatomic, retain) LocationInfo *info;

@property(nonatomic, retain) IBOutlet UILabel  *locationLabel;
@property(nonatomic, retain) IBOutlet UILabel  *infoLabel;
@property(nonatomic, retain) IBOutlet UIImageView  *imageView;

@property(nonatomic) bool *shouldOpenInfo;

-(void) updateInfoWithRegattas:(LocationInfo *)regattas withCommons:(LocationInfo *)commons withEinsteins:(LocationInfo *)einsteins;

@end
