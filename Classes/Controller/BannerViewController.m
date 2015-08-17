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

@synthesize cardView, info;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    cardView = [[RKCardView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 2)];
    
    cardView.coverImageView.image = [UIImage imageNamed:self.photo];
    cardView.profileImageView.image = [self getProfileImageForInfo:info];
    cardView.titleLabel.text = self.label;
    [self.view addSubview:cardView];
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
    UIImage *image = [self getProfileImageForInfo:locationInfo];
    self.cardView.profileImageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewWithLocationInfo:(InfoItem *)locationInfo {
    UIImage *image = [self getProfileImageForInfo:locationInfo];
    self.cardView.profileImageView.image = image;
}

- (UIImage *)getProfileImageForInfo:(InfoItem *)locationInfo {
    NSString *text = @"...";
    UIColor *color = [UIColor grayColor];
    if (locationInfo) {
        text = [NSString stringWithFormat:@"%i", [locationInfo getPeople]];
        CrowdedRating crowdedRating = [InfoItem getCrowdedRatingForInt:[locationInfo getCrowdedRating]];
        color = [InfoItem getColorForCrowdedRating:crowdedRating];
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 5);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIFont *font = [UIFont systemFontOfSize:20.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *textAttributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
    CGSize size = [text sizeWithAttributes:textAttributes];
    CGRect r = CGRectMake(rect.origin.x,
                          rect.origin.y + (rect.size.height - size.height)/2.0,
                          rect.size.width,
                          size.height);
    [text drawInRect:CGRectIntegral(r) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (bool)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(LocationItem *)location {
    if ([[location getName] isEqualToString:self.location]) {
        return true;
    } else {
        return false;
    }
}

@end
