//
//  FeedbackViewController.h
//  CNU
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property(nonatomic, retain) IBOutlet UILabel  *crowdedLabel;
@property(nonatomic, retain) IBOutlet UILabel  *minutesLabel;
@property(nonatomic, retain) IBOutlet UILabel  *feedbackLabel;
@property(nonatomic, weak) IBOutlet UITextField *crowdedField;
@property(nonatomic, weak) IBOutlet UITextField *minutesField;
@property(nonatomic, retain) IBOutlet UITextField *feedbackField;
@property(nonatomic, retain) IBOutlet UIButton  *submitButton;
@property(nonatomic, retain) IBOutlet UILabel  *feedbackResponseTitle;
@property(nonatomic, retain) IBOutlet UILabel  *feedbackResponseDetail;

@property(nonatomic, retain) IBOutlet UIPickerView *crowdedPickerView;
@property(nonatomic, retain) IBOutlet UIPickerView *minutesPickerView;
@property(nonatomic, strong) NSArray *crowdedArray;
@property(nonatomic, strong) NSArray *minutesArray;
@property(nonatomic) int crowdedValue;
@property(nonatomic) int minutesValue;


@end
