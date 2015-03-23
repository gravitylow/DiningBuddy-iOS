//
//  FeedBoxViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 3/18/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import "FeedBoxViewController.h"
#import "WYPopoverController.h"
#import "FeedbackViewController.h"
#import "LocationItem.h"
#import "LocationService.h"

@interface FeedBoxViewController ()

@end

@implementation FeedBoxViewController

@synthesize popover;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFeedback {
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    FeedbackViewController *popoverView = [[FeedbackViewController alloc] initWithNibName:@"FeedbackPopover" bundle:nil];
    popoverView.location = self.location;
    LocationItem *current = [LocationService getLastLocation];
    NSString *locationName = current == nil ? @"" : current.name;
    [popoverView setShowLocationDetail:self.location != nil && locationName == self.location];
    
    if (popover == nil) {
        popover = [[WYPopoverController alloc] initWithContentViewController:popoverView];
    }
    
    [popover presentPopoverFromRect:textField.bounds
                             inView:textField
           permittedArrowDirections:WYPopoverArrowDirectionAny
                           animated:YES
                            options:WYPopoverAnimationOptionFadeWithScale];
    return NO;
}

@end
