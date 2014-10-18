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

@interface ViewController ()

@end

@implementation ViewController

@synthesize regattasView;
@synthesize commonsView;
@synthesize einsteinsView;

@synthesize lastRegattasInfo;
@synthesize lastCommonsInfo;
@synthesize lastEinsteinsInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CNU Dining";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue: %@ (viewcontroller)", segue.identifier);
    LocationViewController *c = [segue destinationViewController];
    if ([segue.identifier hasSuffix:@"Regattas"]) {
        c.location = @"Regattas";
        c.label = @"Regattas";
        c.photo = @"regattas_full.jpg";
        if (lastRegattasInfo) {
            c.info = lastRegattasInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            regattasView = [segue destinationViewController];
        }
    } else if ([segue.identifier hasSuffix:@"Commons"]) {
        c.location = @"Commons";
        c.label = @"The Commons";
        c.photo = @"commons_full.jpg";
        if (lastCommonsInfo) {
            c.info = lastCommonsInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            commonsView = [segue destinationViewController];
        }
    } else if ([segue.identifier hasSuffix:@"Einsteins"]) {
        c.location = @"Einsteins";
        c.label = @"Einstein's";
        c.photo = @"einsteins_full.jpg";
        if (lastEinsteinsInfo) {
            c.info = lastEinsteinsInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            einsteinsView = [segue destinationViewController];
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
    
}

-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location {
    [regattasView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
    [commonsView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
    [einsteinsView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
}

@end
