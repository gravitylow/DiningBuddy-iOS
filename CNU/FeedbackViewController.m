//
//  FeedbackViewController.m
//  CNU
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "FeedbackViewController.h"
#import "TabsController.h"
#import "Api.h"
#import "SettingsService.h"
#import "LocationService.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize crowdedPickerView, minutesPickerView, crowdedValue, minutesValue, crowdedField, minutesField, feedbackField;

- (void)viewDidLoad {
    [super viewDidLoad];
    TabsController *parent = (TabsController *)self.tabBarController;
    self.location = parent.location;
    
    crowdedValue = -1;
    minutesValue = -1;
    self.crowdedArray  = [[NSArray alloc] initWithObjects:@"Not crowded at all",@"Somewhat crowded",@"Very crowded",nil];
    self.minutesArray  = [[NSArray alloc] initWithObjects:@"1 Minute",@"2 Minutes",@"3 Minutes",@"4 Minutes",@"5 Minutes",@"6 Minutes",@"7 Minutes",@"8 Minutes",@"9 Minutes",@"10 Minutes", nil];
    
    self.crowdedPickerView = [[UIPickerView alloc]init];
    self.minutesPickerView = [[UIPickerView alloc]init];
    self.crowdedPickerView.delegate=self;
    self.crowdedPickerView.dataSource=self;
    self.minutesPickerView.delegate=self;
    self.minutesPickerView.dataSource=self;
    self.crowdedField.inputView = self.crowdedPickerView;
    self.minutesField.inputView = self.minutesPickerView;
    
    if (self.submitted) {
        [self setHidden];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.crowdedPickerView) {
        return [self.crowdedArray objectAtIndex:row];
    } else {
        return [self.minutesArray objectAtIndex:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) setHidden {
    self.crowdedLabel.hidden = YES;
    self.crowdedField.hidden = YES;
    self.minutesLabel.hidden = YES;
    self.minutesField.hidden = YES;
    self.feedbackLabel.hidden = YES;
    self.feedbackField.hidden = YES;
    self.submitButton.hidden = YES;
    self.feedbackResponseTitle.hidden = NO;
    self.feedbackResponseDetail.hidden = NO;
}

-(IBAction)submit {
    NSLog(@"SUBMITTED");
    if (crowdedValue == -1 && minutesValue == -1) {
        NSLog(@"RETURNED");
        return;
    } else {
        NSLog(@"SENT");
        [Api sendFeedbackWithTarget:self.location withLocation:[LocationService getLastLocation] withCrowded:crowdedValue withMinutes:minutesValue withFeedback:[feedbackField text] withTime:[SettingsService getTime] withUUID:[SettingsService getUUID]];
        self.submitted = true;
        [self setHidden];
    }
}


@end
