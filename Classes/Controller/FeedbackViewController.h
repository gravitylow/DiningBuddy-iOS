//
//  FeedbackViewController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabsController;
@class Api;
@class BackendService;
@class SettingsService;
@class LocationService;
@class WYPopoverController;
@class CombinedFeedViewController;

@interface FeedbackViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
    bool showLocationDetail;
}

@property(nonatomic, retain) NSString *location;

@property(nonatomic, retain) IBOutlet UILabel *crowdedLabel;
@property(nonatomic, retain) IBOutlet UILabel *minutesLabel;
@property(nonatomic, retain) IBOutlet UILabel *feedbackLabel;
@property(nonatomic, weak) IBOutlet UITextField *crowdedField;
@property(nonatomic, weak) IBOutlet UITextField *minutesField;
@property(nonatomic, retain) IBOutlet UITextField *feedbackField;
@property(nonatomic, retain) IBOutlet UIButton *submitButton;

@property(nonatomic, retain) IBOutlet UIPickerView *crowdedPickerView;
@property(nonatomic, retain) IBOutlet UIPickerView *minutesPickerView;
@property(nonatomic, strong) NSArray *crowdedArray;
@property(nonatomic, strong) NSArray *minutesArray;
@property(nonatomic) NSInteger crowdedValue;
@property(nonatomic) NSInteger minutesValue;

@property(nonatomic, retain) WYPopoverController *wyPopoverController;
@property(nonatomic, retain) CombinedFeedViewController *combinedFeedViewController;

- (IBAction)submit;

- (void)keyboardDidShow:(NSNotification *)notification;


@end
