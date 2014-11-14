//
//  ViewController.m
//  CNU
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LocationViewController.h"
#import "BannerViewController.h"
#import "Location.h"
#import "LocationInfo.h"
#import "BackendService.h"
#import "LocationService.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize regattasView;
@synthesize commonsView;
@synthesize einsteinsView;

@synthesize lastRegattasInfo;
@synthesize lastCommonsInfo;
@synthesize lastEinsteinsInfo;

@synthesize regattasHasBadge;
@synthesize commonsHasBadge;
@synthesize einsteinsHasBadge;

@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"DiningBuddy";
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.scrollView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh {
    [[BackendService getLocationService] requestFullUpdate];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationViewController *c = [segue destinationViewController];
    if ([segue.identifier hasSuffix:@"Regattas"]) {
        c.location = @"Regattas";
        c.label = @"Regattas";
        c.photo = @"regattas_full.jpg";
        c.hasBadge = regattasHasBadge;
        if (lastRegattasInfo) {
            c.info = lastRegattasInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            regattasView = (BannerViewController *)[segue destinationViewController];
        }
    } else if ([segue.identifier hasSuffix:@"Commons"]) {
        c.location = @"Commons";
        c.label = @"The Commons";
        c.photo = @"commons_full.jpg";
        c.hasBadge = commonsHasBadge;
        if (lastCommonsInfo) {
            c.info = lastCommonsInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            commonsView = (BannerViewController *)[segue destinationViewController];
        }
    } else if ([segue.identifier hasSuffix:@"Einsteins"]) {
        c.location = @"Einsteins";
        c.label = @"Einstein's";
        c.photo = @"einsteins_full.jpg";
        c.hasBadge = einsteinsHasBadge;
        if (lastEinsteinsInfo) {
            c.info = lastEinsteinsInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            einsteinsView = (BannerViewController *)[segue destinationViewController];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [AppDelegate registerMainController:self];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppDelegate unregisterMainController];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void) updateInfoWithRegattas:(LocationInfo *)regattas withCommons:(LocationInfo *)commons withEinsteins:(LocationInfo *)einsteins {
    lastRegattasInfo = regattas;
    lastCommonsInfo = commons;
    lastEinsteinsInfo = einsteins;
    [regattasView updateViewWithLocationInfo:regattas];
    [commonsView updateViewWithLocationInfo:commons];
    [einsteinsView updateViewWithLocationInfo:einsteins];
    
    if ([refreshControl isRefreshing]) {
        [refreshControl endRefreshing];
    }
    
}

-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location {
    NSLog(@"Updating all embeded views...");
    regattasHasBadge = [regattasView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
    commonsHasBadge = [commonsView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
    einsteinsHasBadge = [einsteinsView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
}

@end
