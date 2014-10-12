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
#import "LocationInfo.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize regattasView;
@synthesize regattasTitle;
@synthesize regattasInfo;
@synthesize commonsView;
@synthesize commonsTitle;
@synthesize commonsInfo;
@synthesize einsteinsView;
@synthesize einsteinsTitle;
@synthesize einsteinsInfo;

@synthesize lastRegattasInfo;
@synthesize lastCommonsInfo;
@synthesize lastEinsteinsInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CNU Dining";
    
    for (int i=1;i<=3;i++) {
        UIImageView *view = (UIImageView *)[self.view viewWithTag:i];
        view.contentMode = UIViewContentModeScaleToFill;
        view.center = self.view.center;
        
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 10.0;
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    self.regattasInfo.textAlignment = NSTextAlignmentCenter;
    self.commonsInfo.textAlignment = NSTextAlignmentCenter;
    self.einsteinsInfo.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"Regattas"]) {
        LocationViewController *c = [segue destinationViewController];
        c.location = @"Regattas";
        c.label = @"Regattas";
        c.photo = @"regattas_full.jpg";
        if (lastRegattasInfo) {
            c.initialInfo = lastRegattasInfo;
        }
    } else if ([segue.identifier isEqualToString:@"Commons"]) {
        LocationViewController *c = [segue destinationViewController];
        c.location = @"Commons";
        c.label = @"The Commons";
        c.photo = @"commons_full.jpg";
        if (lastCommonsInfo) {
            c.initialInfo = lastCommonsInfo;
        }
    } else if ([segue.identifier isEqualToString:@"Einsteins"]) {
        LocationViewController *c = [segue destinationViewController];
        c.location = @"Einsteins";
        c.label = @"Einstein's";
        c.photo = @"einsteins_full.jpg";
        if (lastEinsteinsInfo) {
            c.initialInfo = lastEinsteinsInfo;
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
    [self updateView:regattasView andTitle:regattasTitle andInfo:regattasInfo withLocationInfo:regattas];
    [self updateView:commonsView andTitle:commonsTitle andInfo:commonsInfo withLocationInfo:commons];
    [self updateView:einsteinsView andTitle:einsteinsTitle andInfo:einsteinsInfo withLocationInfo:einsteins];
    
}

-(void) updateView: (UIImageView *)view andTitle:(UILabel *)title andInfo:(UILabel *)info withLocationInfo:(LocationInfo *)locationInfo {
    CrowdedRating crowdedRating = [LocationInfo getCrowdedRatingForInt:[locationInfo getCrowdedRating]];
    UIColor *color = [LocationInfo getColorForCrowdedRating:crowdedRating];
    view.layer.borderColor = [color CGColor];
    title.textColor = color;
    info.text = [NSString stringWithFormat:@"Currently: %i people", [locationInfo getPeople]];
}

@end
