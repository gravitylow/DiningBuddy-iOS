//
//  LocationViewController.h
//  CNU
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class Location;
@class LocationInfo;

@interface LocationViewController : UIViewController <UITabBarControllerDelegate, UIWebViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property(nonatomic) int crowdedValue;
@property(nonatomic) int minutesValue;
@property(nonatomic) id feedbackTab;

@property(nonatomic, retain) NSString  *location;
@property(nonatomic, retain) NSString  *label;
@property(nonatomic, retain) NSString  *photo;
@property(nonatomic, retain) LocationInfo *initialInfo;

@property(nonatomic, retain) IBOutlet UILabel  *locationLabel;
@property(nonatomic, retain) IBOutlet UILabel  *infoLabel;
@property(nonatomic, retain) IBOutlet UIImageView  *imageView;
@property(nonatomic, retain) IBOutlet UIWebView  *webView;
@property(nonatomic, retain) IBOutlet UITabBar  *tabBar;

@property(nonatomic, retain) IBOutlet UIPickerView *crowdedPickerView;
@property(nonatomic, retain) IBOutlet UIPickerView *minutesPickerView;
@property(nonatomic, retain) IBOutlet UILabel  *crowdedLabel;
@property(nonatomic, retain) IBOutlet UILabel  *minutesLabel;
@property(nonatomic, retain) IBOutlet UILabel  *feedbackLabel;
@property(nonatomic, weak) IBOutlet UITextField *crowdedField;
@property(nonatomic, weak) IBOutlet UITextField *minutesField;
@property(nonatomic, retain) IBOutlet UITextField *feedbackField;
@property(nonatomic, retain) IBOutlet UIButton  *submitButton;
@property(nonatomic, retain) IBOutlet UILabel  *feedbackResponseTitle;
@property(nonatomic, retain) IBOutlet UILabel  *feedbackResponseDetail;
@property(nonatomic, strong) NSArray *crowdedArray;
@property(nonatomic, strong) NSArray *minutesArray;

-(void) updateInfoWithRegattas:(LocationInfo *)regattas withCommons:(LocationInfo *)commons withEinsteins:(LocationInfo *)einsteins;
-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location;
@end
