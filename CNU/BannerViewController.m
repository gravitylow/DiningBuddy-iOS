//
//  BannerViewController.m
//  CNU
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "BannerViewController.h"
#import "LocationInfo.h"

@interface BannerViewController ()

@end

@implementation BannerViewController

@synthesize locationLabel, infoLabel, imageView, info, shouldOpenInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loading banner");
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    self.locationLabel.text = self.label;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImage *image = [UIImage imageNamed: self.photo];
    [self.imageView setImage:image];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.center = self.view.center;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 10.0;
    self.imageView.layer.borderWidth = 1.0;
    if (self.info) {
        [self updateInfoWithRegattas:info withCommons:info withEinsteins:info];
    } else {
        self.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    NSLog(@"Done loading banner");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
