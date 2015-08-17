//
//  FeedbackViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CombinedFeedViewController.h"
#import "FeedViewController.h"
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
    
    [self.feedbackField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardDidShow:(NSNotification *)notification {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
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
    item.crowded = [NSNumber numberWithInteger:crowdedValue];
    item.minutes = [NSNumber numberWithInteger:minutesValue];
    item.feedback = [feedbackField text];
    item.send_time = [NSNumber numberWithLongLong:[SettingsService getTime]];

    [API sendFeedback:item];
    NSString *location = self.location;
    SettingsService *settings = [BackendService getSettingsService];
    [settings setLastFeedbackWithLocationName:location :[SettingsService getTime]];
    
    NSLog(@"Dismiss");
    [self.wyPopoverController dismissPopoverAnimated:YES];
    [self.combinedFeedViewController.feedViewController getFeed];
}

@end
