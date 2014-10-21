//
//  MenuViewController.h
//  CNU
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationFeedItem;
@class Api;
@class SettingsService;

@interface FeedViewController : UITableViewController <UITableViewDelegate, UITableViewDelegate>

@property(nonatomic, retain) NSString  *location;
@property(nonatomic, retain) NSArray *data;

-(void)setFeed:(NSArray *)array;

@end
