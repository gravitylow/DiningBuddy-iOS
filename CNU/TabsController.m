//
//  TabsController.m
//  CNU
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "TabsController.h"
#import "LocationInfo.h"
#import "FeedbackViewController.h"
#import "GraphViewController.h"
#import "BackendService.h"
#import "LocationService.h"
#import "SettingsService.h"
#import "Location.h"
#import "MenuViewController.h"
#import "FeedViewController.h"

@implementation TabsController

long const MIN_FEEDBACK = 30 * 60 * 1000;

int const TAB_LOCATION_MENU = 1;
int const TAB_LOCATION_HOURS = 2;
int const TAB_LOCATION_FEED = 3;
int const TAB_LOCATION_FEEDBACK = 4;
int const TAB_SIZE_FULL = 4;

@synthesize location;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loading tab controller");
    NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self viewControllers]];

    FeedViewController *c = [tabbarViewControllers objectAtIndex:TAB_LOCATION_FEED];
    c.location = self.location;
    if (![self shouldShowFeedback:[LocationService getLastLocation]]) {
        self.feedbackTabItem = [tabbarViewControllers objectAtIndex:TAB_LOCATION_FEEDBACK];
        [tabbarViewControllers removeObjectAtIndex:TAB_LOCATION_FEEDBACK];
    }
    if ([location isEqualToString:@"Einsteins"]) {
        [tabbarViewControllers removeObjectAtIndex:TAB_LOCATION_MENU];
    } else {
        MenuViewController *c = [tabbarViewControllers objectAtIndex:TAB_LOCATION_MENU];
        c.location = self.location;
        [tabbarViewControllers removeObjectAtIndex:TAB_LOCATION_HOURS];
    }
    [self setViewControllers: tabbarViewControllers];
}

-(bool)shouldShowFeedback:(Location *)loc {
    bool add = false;
    if ([[loc getName] isEqualToString:location]) {
        long long last;
        SettingsService *settings = [BackendService getSettingsService];
        if ([location isEqualToString:@"Regattas"]) {
            last = [settings getLastFeedbackRegattas];
        } else if ([location isEqualToString:@"Commons"]) {
            last = [settings getLastFeedbackCommons];
        } else if ([location isEqualToString:@"Einsteins"]) {
            last = [settings getLastFeedbackEinsteins];
        }
        add = last == -1 || last == 0 || ([SettingsService getTime] - last) > MIN_FEEDBACK;
    }
    //return add;
    return true;
}

- (void) tabBarController:(UITabBarController *) tabBarController
 didSelectViewController:(UIViewController *) viewController {
    NSLog(@"Selected: %@", [viewController description]);
}

-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location {
    bool shouldShowFeedback = [self shouldShowFeedback:location];
    NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self viewControllers]];
    if (shouldShowFeedback/*[tabbarViewControllers count] != TAB_SIZE_FULL*/) {
        if ([tabbarViewControllers count] != TAB_SIZE_FULL && self.feedbackTabItem) {
            [tabbarViewControllers addObject:self.feedbackTabItem];
        }
    } else {
        if ([tabbarViewControllers count] == TAB_SIZE_FULL) {
            NSLog(@"Removing item...");
            self.feedbackTabItem = [tabbarViewControllers objectAtIndex:TAB_LOCATION_FEEDBACK - 1];
            [tabbarViewControllers removeObjectAtIndex:TAB_LOCATION_FEEDBACK - 1];
        }
    }
    [self setViewControllers: tabbarViewControllers];
}

@end
