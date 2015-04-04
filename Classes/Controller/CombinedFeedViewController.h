//
//  CombinedFeedViewController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 3/18/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedViewController;
@class FeedBoxViewController;

@interface CombinedFeedViewController : UIViewController

@property(strong, nonatomic) NSString *location;
@property(nonatomic, retain) IBOutlet UIView *feedView;
@property(nonatomic, retain) FeedViewController *feedViewController;
@property(nonatomic, retain) IBOutlet UIView *feedBoxView;
@property(nonatomic, retain) FeedBoxViewController *feedBoxViewController;
@property(nonatomic, retain) NSLayoutConstraint *constraint;

@end
