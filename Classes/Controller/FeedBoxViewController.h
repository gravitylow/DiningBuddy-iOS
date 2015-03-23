//
//  FeedBoxViewController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 3/18/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYPopoverController;
@class FeedbackViewController;
@class LocationItem;
@class LocationService;

@interface FeedBoxViewController : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate>

@property(nonatomic, retain) NSString *location;
@property(nonatomic, strong) WYPopoverController *popover;

@end
