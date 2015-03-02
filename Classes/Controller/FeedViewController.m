//
//  MenuViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedItem.h"
#import "API.h"
#import "SettingsService.h"

@implementation FeedViewController

@synthesize data;
@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[NSArray alloc] init];
    [self getFeed];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(getFeed) forControlEvents:UIControlEventValueChanged];
}

- (void)getFeed {
    [API getFeedForLocationName:self.location :^(NSArray *feed) {
        dataLoaded = true;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (FeedItem *item in feed) {
            if (item.pinned) {
                [temp insertObject:item atIndex:0];
            } else {
                [temp addObject:item];
            }
        }
        self.data = temp;
        [self.tableView reloadData];
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }

    FeedItem *item = data[indexPath.row];

    if (item.pinned) {
        cell.backgroundColor = [UIColor colorWithRed:0.165 green:0.69 blue:0.506 alpha:1]; /*#2ab081*/
    }

    NSLog(@"Item time: %lli", item.time);
    NSLog(@"Current time: %lli", [SettingsService getTime]);
    NSLog(@"Message: %@", item.message);
    cell.textLabel.text = item.message;
    cell.detailTextLabel.text = [self minutesAgo:item.time];
    return cell;
}

- (NSString *)minutesAgo:(long long)time {
    long long diff = [SettingsService getTime] - time;
    double mins = (diff / 1000) / 60;
    if (mins < 1) {
        return @"< 1 minute ago";
    } else if (mins >= 1 && mins < 2) {
        return @"1 minute ago";
    } else {
        return [NSString stringWithFormat:@"%i minutes ago", (int) mins];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([data count] > 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
        return 1;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

        messageLabel.text = dataLoaded ? @"No recent updates" : @"Loading...";
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];

        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedItem *item = data[indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback"
                                                    message:item.message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
