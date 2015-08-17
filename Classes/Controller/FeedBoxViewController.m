//
//  FeedBoxViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 3/18/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedBoxViewController.h"
#import "WYPopoverController.h"
#import "FeedbackViewController.h"
#import "CombinedFeedViewController.h"
#import "LocationItem.h"
#import "BackendService.h"
#import "SettingsService.h"
#import "LocationService.h"
#import "FeedbackItem.h"
#import "API.h"

@interface FeedBoxViewController ()

@end

@implementation FeedBoxViewController

@synthesize popover;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submit {
    if (self.allowSubmit) {
        NSString *feedback = self.feedbackField.text;
        bool err = false;
        UIColor *errColor = [UIColor colorWithRed:0.851 green:0.255 blue:0.188 alpha:1]; /*#d94130*/
        if ([feedback length] == 0) {
            NSLog(@"ERR: FEEDBACK");
            self.feedbackField.backgroundColor = errColor;
            err = true;
            return;
        }
        
        NSString *current = [[LocationService getLastLocation] getName];
        if (current == nil) {
            current = @"Unknown";
        }
        
        
        NSLog(@"SUBMITTING");
        FeedbackItem *item = [[FeedbackItem alloc] init];
        item.uuid = [SettingsService getUUID];
        item.target = self.location;
        item.location = current;
        item.crowded = [NSNumber numberWithInt:-1];
        item.minutes = [NSNumber numberWithInt:-1];
        item.feedback = [self.feedbackField text];
        item.send_time = [NSNumber numberWithLongLong:[SettingsService getTime]];
        
        [API sendFeedback:item];
        [self.feedbackField setText:@""];
        NSString *location = self.location;
        SettingsService *settings = [BackendService getSettingsService];
        [settings setLastFeedbackWithLocationName:location :[SettingsService getTime]];
        
        [self.combinedFeedViewController.feedViewController getFeed];
        [self.feedbackField resignFirstResponder];
    }
}

- (void)checkFeedbackAnimated:(BOOL)animate {
    [self animateFeedbackWithValue:[self shouldShowFeedback] animated:animate];
}

- (BOOL) shouldShowFeedback {
    NSString *location = self.location;
    SettingsService *settings = [BackendService getSettingsService];
    long long lastUpdate = [settings getLastFeedbackWithLocationName:location];
    return ([SettingsService getTime] - lastUpdate) >= MIN_FEEDBACK_INTERVAL;
}


- (void) animateFeedbackWithValue:(BOOL) visible animated:(BOOL)animate {
    float v = visible ? 1.0 : 0.0;
    if (v == self.view.alpha) {
        return;
    }
    if (animate) {
        [UIView animateWithDuration:0.5
                              delay:0.5
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = self.view.frame;
                             int d = visible ? 0 : frame.size.height;
                             frame.origin.y = d;
                             self.view.frame = frame;
                             [self.view setAlpha:v];
                         }
                         completion:^(BOOL finished){
                         }];
    } else {
        CGRect frame = self.view.frame;
        int d = visible ? 0 : frame.size.height;
        frame.origin.y = d;
        self.view.frame = frame;
        [self.view setAlpha:v];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    FeedbackViewController *popoverView = [[FeedbackViewController alloc] initWithNibName:@"FeedbackPopover" bundle:nil];
    popoverView.location = self.location;
    popoverView.combinedFeedViewController = self.combinedFeedViewController;
    LocationItem *current = [LocationService getLastLocation];
    NSString *locationName = current == nil ? @"" : current.name;
    BOOL showLocationDetails = self.location != nil && locationName == self.location;
    if (showLocationDetails) {
        if (popover == nil) {
            popover = [[WYPopoverController alloc] initWithContentViewController:popoverView];
        }
        
        [popover presentPopoverFromRect:textField.bounds
                                 inView:textField
               permittedArrowDirections:WYPopoverArrowDirectionAny
                               animated:YES
                                options:WYPopoverAnimationOptionFadeWithScale];
        NSLog(@"Allow submit NO");
        self.allowSubmit = NO;
        return NO;
    } else {
        NSLog(@"Allow submit YES");
        self.allowSubmit = YES;
        return YES;
    }
}

@end
