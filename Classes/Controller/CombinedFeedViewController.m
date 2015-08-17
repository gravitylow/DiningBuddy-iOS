//
//  CombinedFeedViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 3/18/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import "CombinedFeedViewController.h"
#import "FeedViewController.h"
#import "FeedBoxViewController.h"

@interface CombinedFeedViewController ()

@end

@implementation CombinedFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.feedBoxViewController != nil) {
        [self.feedBoxViewController checkFeedbackAnimated:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"feed"]) {
        FeedViewController *vc = [segue destinationViewController];
        self.feedViewController = vc;
        self.feedViewController.location = self.location;
        self.feedViewController.combinedFeedViewController = self;
    } else if ([segue.identifier isEqualToString:@"feedbox"]) {
        FeedBoxViewController *vc = [segue destinationViewController];
        self.feedBoxViewController = vc;
        self.feedBoxViewController.location = self.location;
        self.feedBoxViewController.combinedFeedViewController = self;
        [self.feedBoxViewController checkFeedbackAnimated:NO];
    }
}

@end