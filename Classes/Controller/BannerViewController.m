//
//  BannerViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "BannerViewController.h"
#import "LocationItem.h"
#import "InfoItem.h"

@interface BannerViewController ()

@end

@implementation BannerViewController

@synthesize locationLabel, infoLabel, imageView, info, badgeImageView, hasBadge;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationLabel.text = self.label;
    
    self.locationLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    self.infoLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    
    UIImage *image = [UIImage imageNamed:self.photo];
    [self.imageView setImage:image];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.center = self.view.center;
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 1.0;
    
    [badgeImageView setHidden:!hasBadge];
    if (self.info) {
        [self updateInfoWithRegattas:info withCommons:info withEinsteins:info];
    } else {
        self.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    }
}

- (void)updateInfoWithRegattas:(InfoItem *)regattas withCommons:(InfoItem *)commons withEinsteins:(InfoItem *)einsteins {
    InfoItem *locationInfo;
    if ([self.location isEqualToString:@"Regattas"]) {
        locationInfo = regattas;
    } else if ([self.location isEqualToString:@"Commons"]) {
        locationInfo = commons;
    } else if ([self.location isEqualToString:@"Einsteins"]) {
        locationInfo = einsteins;
    }
    CrowdedRating crowdedRating = [InfoItem getCrowdedRatingForInt:[locationInfo getCrowdedRating]];
    UIColor *color = [InfoItem getColorForCrowdedRating:crowdedRating];
    self.imageView.layer.borderColor = [color CGColor];
    self.locationLabel.textColor = color;
    self.infoLabel.text = [NSString stringWithFormat:@"Currently: %i people", [locationInfo getPeople]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewWithLocationInfo:(InfoItem *)locationInfo {
    CrowdedRating crowdedRating = [InfoItem getCrowdedRatingForInt:[locationInfo getCrowdedRating]];
    UIColor *color = [InfoItem getColorForCrowdedRating:crowdedRating];
    imageView.layer.borderColor = [color CGColor];
    locationLabel.textColor = color;
    infoLabel.text = [NSString stringWithFormat:@"Currently: %i people", [locationInfo getPeople]];
}

- (bool)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(LocationItem *)location {
    if ([[location getName] isEqualToString:self.location]) {
        [badgeImageView setHidden:FALSE];
        return true;
    } else {
        [badgeImageView setHidden:TRUE];
        return false;
    }
}

@end
