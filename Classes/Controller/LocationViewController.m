//
//  LocationViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "LocationViewController.h"
#import "AppDelegate.h"
#import "BannerViewController.h"
#import "TabsController.h"
#import "InfoItem.h"
#import "LocationItem.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"showLocation" object:nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [AppDelegate registerLocationController:self];
    [self.banner.cardView addBlur];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppDelegate unregisterLocationController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Banner"]) {
        BannerViewController *c = [segue destinationViewController];
        c.location = self.location;
        c.label = self.label;
        c.photo = self.photo;
        if (self.info) {
            c.info = self.info;
        }
        self.banner = c;
    } else if ([segue.identifier isEqualToString:@"Tabs"]) {
        TabsController *c = [segue destinationViewController];
        c.location = self.location;
        if (self.info) {
            c.info = self.info;
        }
        self.tabs = c;
    }
}

- (void)updateInfoWithRegattas:(InfoItem *)regattas withCommons:(InfoItem *)commons withEinsteins:(InfoItem *)einsteins {
    InfoItem *locationInfo;
    if ([self.label isEqualToString:@"Regatta's"]) {
        locationInfo = regattas;
    } else if ([self.label isEqualToString:@"Commons"]) {
        locationInfo = commons;
    } else if ([self.label isEqualToString:@"Einstein's"]) {
        locationInfo = einsteins;
    }
    [self.banner updateViewWithLocationInfo:locationInfo];
}

- (void)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(LocationItem *)location {
    [self.tabs updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
}

@end
