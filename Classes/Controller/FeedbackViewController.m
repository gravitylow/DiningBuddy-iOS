//
//  FeedbackViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "FeedbackViewController.h"
#import "TabsController.h"
#import "API.h"
#import "BackendService.h"
#import "SettingsService.h"
#import "LocationService.h"
#import "InfoItem.h"
#import "LocationItem.h"
#import "FeedbackItem.h"
#import "WYPopoverController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

@synthesize crowdedPickerView, minutesPickerView, crowdedValue, minutesValue, crowdedField, minutesField, feedbackField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self->showLocationDetail = true;
    
    crowdedValue = -1;
    minutesValue = -1;
    self.crowdedArray = [InfoItem getFeedbackList];
    self.minutesArray = @[@"0 Minutes", @"1 Minute", @"2 Minutes", @"3 Minutes", @"4 Minutes", @"5 Minutes", @"6 Minutes", @"7 Minutes", @"8 Minutes", @"9 Minutes", @"10+ Minutes"];
    
    self.crowdedPickerView = [[UIPickerView alloc] init];
    self.minutesPickerView = [[UIPickerView alloc] init];
    self.crowdedPickerView.delegate = self;
    self.crowdedPickerView.dataSource = self;
    self.minutesPickerView.delegate = self;
    self.minutesPickerView.dataSource = self;
    self.crowdedField.inputView = self.crowdedPickerView;
    self.minutesField.inputView = self.minutesPickerView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardDidShow:(NSNotification *)notification {
    
    UITextField *field = [crowdedField isFirstResponder] ? crowdedField : [minutesField isFirstResponder] ? minutesField : feedbackField;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    currentKeyboardHeight = kbSize.height;
    
    CGRect textFieldRect = [self.view.window convertRect:field.bounds fromView:field];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    animatedDistance = floor(currentKeyboardHeight * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.crowdedPickerView) {
        return 3;
    } else {
        return 10;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.crowdedPickerView) {
        return self.crowdedArray[row];
    } else {
        return self.minutesArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.crowdedPickerView) {
        crowdedValue = row;
        self.crowdedField.text = self.crowdedArray[row];
        [self.crowdedField resignFirstResponder];
    } else if (pickerView == self.minutesPickerView) {
        minutesValue = row;
        self.minutesField.text = self.minutesArray[row];
        [self.minutesField resignFirstResponder];
    }
}

- (IBAction)submit {
    bool err = false;
    UIColor *errColor = [UIColor colorWithRed:0.851 green:0.255 blue:0.188 alpha:1]; /*#d94130*/
    if ([self.feedbackField.text length] == 0) {
        NSLog(@"ERR: FEEDBACK");
        self.crowdedField.backgroundColor = errColor;
        err = true;
    }
    if (self->showLocationDetail && crowdedValue == -1) {
        NSLog(@"ERR: CROWDED");
        self.crowdedField.backgroundColor = errColor;
        err = true;
    }
    if (self->showLocationDetail && minutesValue == -1) {
        NSLog(@"ERR: MINUTES");
        self.minutesField.backgroundColor = errColor;
        err = true;
    }
    if (err) {
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
    item.crowded = [NSNumber numberWithInt:crowdedValue];
    item.minutes = [NSNumber numberWithInt:minutesValue];
    item.feedback = [feedbackField text];
    item.send_time = [NSNumber numberWithLongLong:[SettingsService getTime]];

    [API sendFeedback:item];
    NSString *location = ((TabsController *) self.tabBarController).location;
    SettingsService *settings = [BackendService getSettingsService];
    if ([location isEqualToString:@"Regattas"]) {
        [settings setLastFeedbackRegattas:[SettingsService getTime]];
    } else if ([location isEqualToString:@"Commons"]) {
        [settings setLastFeedbackCommons:[SettingsService getTime]];
    } else if ([location isEqualToString:@"Einsteins"]) {
        [settings setLastFeedbackEinsteins:[SettingsService getTime]];
    }
    [self.wyPopoverController dismissPopoverAnimated:YES];
}

- (void)setShowLocationDetail:(bool)show {
    self->showLocationDetail = show;
    [self.crowdedField setHidden:show];
    [self.crowdedLabel setHidden:show];
    [self.minutesField setHidden:show];
    [self.minutesLabel setHidden:show];
}


@end
