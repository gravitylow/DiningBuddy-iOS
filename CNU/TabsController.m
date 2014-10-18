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
#import "Location.h"

@implementation TabsController

- (void) tabBarController:(UITabBarController *) tabBarController
 didSelectViewController:(UIViewController *) viewController {
    NSLog(@"Selected: %@", [viewController description]);
}

-(void)updateLocationWithLatitude: (double)latitude withLongitude:(double)longitude withLocation:(Location *)location {
    NSLog(@"Location updated to tabsController");
    bool shouldShowFeedback = [[location getName] isEqualToString:self.label];
    NSLog(@"Should show feedback: %i", shouldShowFeedback);
    NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self viewControllers]];
    if (shouldShowFeedback/*[tabbarViewControllers count] != 2*/) {
        if ([tabbarViewControllers count] != 2 && self.feedbackTabItem) {
            [tabbarViewControllers addObject:self.feedbackTabItem];
        }
    } else {
        if ([tabbarViewControllers count] == 2) {
            NSLog(@"Removing item...");
            self.feedbackTabItem = [tabbarViewControllers objectAtIndex:1];
            [tabbarViewControllers removeObjectAtIndex:1];
        }
    }
    [self setViewControllers: tabbarViewControllers];
}

@end
