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
#import "LocationViewController.h"

@interface ViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIImageView  *regattasView;
@property(nonatomic, retain) IBOutlet UILabel  *regattasTitle;
@property(nonatomic, retain) IBOutlet UILabel  *regattasInfo;
@property(nonatomic, strong) IBOutlet UIImageView  *commonsView;
@property(nonatomic, retain) IBOutlet UILabel  *commonsTitle;
@property(nonatomic, retain) IBOutlet UILabel  *commonsInfo;
@property(nonatomic, strong) IBOutlet UIImageView  *einsteinsView;
@property(nonatomic, retain) IBOutlet UILabel  *einsteinsTitle;
@property(nonatomic, retain) IBOutlet UILabel  *einsteinsInfo;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapRecognizer;
//-(IBAction)fetchLocations;

@end

