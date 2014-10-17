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

@implementation TabsController

- (void) tabBarController:(UITabBarController *) tabBarController
 didSelectViewController:(UIViewController *) viewController {
    NSLog(@"Selected: %@", [viewController description]);
}

@end
