//
//  FeedBoxViewController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 3/18/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYPopoverController;
@class FeedViewController;
@class FeedbackViewController;
@class CombinedFeedViewController;
@class LocationItem;
@class BackendService;
@class SettingsService;
@class LocationService;
@class FeedbackItem;
@class API;

@interface FeedBoxViewController : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate>

@property(nonatomic, retain) IBOutlet UITextField *feedbackField;
@property(nonatomic, retain) IBOutlet UIButton *submitButton;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) CombinedFeedViewController *combinedFeedViewController;
@property(nonatomic, strong) WYPopoverController *popover;
@property(nonatomic) BOOL allowSubmit;

- (void)checkFeedbackAnimated:(BOOL)animate;

@end
