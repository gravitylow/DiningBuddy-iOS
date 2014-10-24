//
//  LocationViewController.m
//  CNU
//
//  Created by Adam Fendley on 10/9/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "LocationViewController.h"
#import "AppDelegate.h"
#import "BannerViewController.h"
#import "TabsController.h"
#import "LocationInfo.h"
#import "Location.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize location, label, photo, info, banner, tabs, hasBadge;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [AppDelegate registerLocationController:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppDelegate unregisterLocationController];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue: %@ (locationviewcontroller)", segue.identifier);
    if ([segue.identifier isEqualToString:@"Banner"]) {
        BannerViewController *c = [segue destinationViewController];
        c.location = self.location;
        c.label = self.label;
        c.photo = self.photo;
        c.hasBadge = self.hasBadge;
        if (self.info) {
            c.info = self.info;
        }
        banner = c;
    } else if ([segue.identifier isEqualToString:@"Tabs"]) {
        TabsController *c = [segue destinationViewController];
        c.location = self.location;
        c.label = self.label;
        c.photo = self.photo;
        if (self.info) {
            c.info = self.info;
        }
        tabs = c;
    }
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
    [banner updateViewWithLocationInfo:locationInfo];
}

-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location {
    [tabs updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
}

@end
