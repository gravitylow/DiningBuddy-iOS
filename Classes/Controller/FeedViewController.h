//
//  MenuViewController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedItem;
@class InfoItem;
@class Api;
@class SettingsService;
@class CombinedFeedViewController;
@class FeedBoxViewController;

@interface FeedViewController : UITableViewController <UITableViewDelegate, UITableViewDelegate> {
    bool dataLoaded;
}

@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSArray *data;
@property(nonatomic, retain) CombinedFeedViewController *combinedFeedViewController;
@property(nonatomic, retain) UIRefreshControl *refreshControl;

@property(strong, nonatomic) IBOutlet UITableView *tableView;

-(void) getFeed;

@end
