//
//  CombinedFeedViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 3/18/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import "CombinedFeedViewController.h"
#import "FeedBoxViewController.h"

@interface CombinedFeedViewController ()

@end

@implementation CombinedFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"feedbox"]) {
        FeedBoxViewController *vc = [segue destinationViewController];
        vc.location = self.location;
    }
}

@end