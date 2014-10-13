//
//  LocationViewController.m
//  CNU
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "LocationViewController.h"
#import "AppDelegate.h"
#import "LocationInfo.h"
#import "Location.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize crowdedValue;
@synthesize minutesValue;
@synthesize feedbackTab;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    self.locationLabel.text = self.label;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    
    feedbackTab = [[self.tabBarController viewControllers] objectAtIndex:1];
    
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
    
    NSLog(@"crowded picker: %@", self.crowdedPickerView);
    
    NSString *urlAddress = @"https://api.gravitydevelopment.net/cnu/api/v1.0/graphs/";
    urlAddress = [urlAddress stringByAppendingString:self.location];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    self.feedbackField.delegate = self;
    
    UIImage *image = [UIImage imageNamed: self.photo];
    [self.imageView setImage:image];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.center = self.view.center;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 10.0;
    self.imageView.layer.borderWidth = 1.0;
    if (self.initialInfo) {
        [self updateInfoWithRegattas:self.initialInfo withCommons:self.initialInfo withEinsteins:self.initialInfo];
    } else {
        self.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = rw;
    webView.scrollView.maximumZoomScale = rw;
    webView.scrollView.zoomScale = rw;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"diSelectViewController %@", viewController.description);
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"diSelectItem %@", item.title);
    if ([item.title isEqualToString:@"Activity"]) {
        self.webView.hidden = NO;
        
        [self setFeedbackHidden:true];
        self.feedbackResponseTitle.hidden = YES;
        self.feedbackResponseDetail.hidden = YES;
    } else if ([item.title isEqualToString:@"Feedback"]) {
        self.webView.hidden = YES;
        
        [self setFeedbackHidden:false];
        
        // TODO feedback implementation
        //self.feedbackResponseTitle.hidden = YES;
        //self.feedbackResponseDetail.hidden = YES;
    }
}

- (void) setFeedbackHidden: (bool) hidden {
    self.crowdedLabel.hidden = hidden;
    self.crowdedField.hidden = hidden;
    self.minutesLabel.hidden = hidden;
    self.minutesField.hidden = hidden;
    self.feedbackLabel.hidden = hidden;
    self.feedbackField.hidden = hidden;
    self.submitButton.hidden = hidden;
}

- (void) setFeedbackTabHidden: (bool) hidden {
    NSMutableArray * vcs = [NSMutableArray arrayWithArray:[self.tabBarController viewControllers]];
    if (hidden) {
        [vcs removeObject:feedbackTab];
    } else {
        [vcs addObject:feedbackTab];
    }
    [self.tabBarController setViewControllers:vcs];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [AppDelegate registerLocationController:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppDelegate unregisterLocationController];
}

-(void) updateInfoWithRegattas:(LocationInfo *)regattas withCommons:(LocationInfo *)commons withEinsteins:(LocationInfo *)einsteins {
    LocationInfo *locationInfo;
    if ([self.label isEqualToString:@"Regattas"]) {
        locationInfo = regattas;
    } else if ([self.label isEqualToString:@"Commons"]) {
        locationInfo = commons;
    } else if ([self.label isEqualToString:@"Einsteins"]) {
        locationInfo = einsteins;
    }
    CrowdedRating crowdedRating = [LocationInfo getCrowdedRatingForInt:[locationInfo getCrowdedRating]];
    UIColor *color = [LocationInfo getColorForCrowdedRating:crowdedRating];
    self.imageView.layer.borderColor = [color CGColor];
    self.locationLabel.textColor = color;
    self.infoLabel.text = [NSString stringWithFormat:@"Currently: %i people", [locationInfo getPeople]];
}

-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location {[self setFeedbackHidden:![[location getName] isEqualToString:self.label]];
}

@end
