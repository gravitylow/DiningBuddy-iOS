//
//  MenuViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedItem.h"
#import "InfoItem.h"
#import "API.h"
#import "SettingsService.h"
#import "CombinedFeedViewController.h"
#import "FeedBoxViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

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
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)getFeed {
    [API getFeedForLocationName:self.location :^(NSArray *feed) {
        dataLoaded = true;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (FeedItem *item in feed) {
            if ([item isPinned]) {
                [temp insertObject:item atIndex:0];
            } else {
                [temp addObject:item];
            }
        }
        // Uncomment for demo
//        FeedItem *item1 = [[FeedItem alloc] init];
//        item1.uuid = [SettingsService getUUID];
//        item1.feedback = @"Pretty long lines today, lots of open seats though";
//        item1.detail = @"Pretty long lines today, lots of open seats though";
//        item1.target = self.location;
//        item1.crowded = [NSNumber numberWithInteger:1];
//        item1.minutes = [NSNumber numberWithInteger:4];
//        item1.time = [NSNumber numberWithLongLong:[SettingsService getTime]];
//        item1.send_time = [NSNumber numberWithLongLong:[SettingsService getTime]];
//        item1.pinned = [NSNumber numberWithInteger:0];
//        [temp addObject:item1];
//        FeedItem *item2 = [[FeedItem alloc] init];
//        item2.uuid = [SettingsService getUUID];
//        item2.feedback = @"Mr. Greg is the man!";
//        item2.detail = @"Mr. Greg is the man!";
//        item2.target = self.location;
//        item2.crowded = [NSNumber numberWithInteger:-1];
//        item2.minutes = [NSNumber numberWithInteger:-1];
//        item2.time = [NSNumber numberWithLongLong:[SettingsService getTime] - 1000 * 60 * 7];
//        item2.send_time = [NSNumber numberWithLongLong:[SettingsService getTime]];
//        item2.pinned = [NSNumber numberWithInteger:0];
//        [temp addObject:item2];
//        FeedItem *item3 = [[FeedItem alloc] init];
//        item3.uuid = [SettingsService getUUID];
//        item3.feedback = @"TENDER TUESDAY IS WORTH THE WAIT!";
//        item3.detail = @"TENDER TUESDAY IS WORTH THE WAIT!";
//        item3.target = self.location;
//        item3.crowded = [NSNumber numberWithInteger:1];
//        item3.minutes = [NSNumber numberWithInteger:1];
//        item3.time = [NSNumber numberWithLongLong:[SettingsService getTime] - 1000 * 60 * 15];
//        item3.send_time = [NSNumber numberWithLongLong:[SettingsService getTime]];
//        item3.pinned = [NSNumber numberWithInteger:0];
//        [temp addObject:item3];
        self.data = temp;
        [self.tableView reloadData];
        [self.combinedFeedViewController.feedBoxViewController checkFeedbackAnimated:YES];
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
    
    if ([item isPinned]) {
        cell.backgroundColor = [UIColor colorWithRed:0.165 green:0.69 blue:0.506 alpha:1]; /*#2ab081*/
        cell.detailTextLabel.text = @"Announcement";
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    } else {
        cell.detailTextLabel.text = [self minutesAgo:[item.time longLongValue]];
    }
    
    if ([item.crowded intValue] != -1 && [item.minutes intValue] != -1) {
        cell.imageView.image = [UIImage imageNamed:@"location-marker.png"];
    }
    
    cell.textLabel.text = item.feedback;
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
    NSString *message = item.feedback;
    NSString *title = @"Feedback";
    if ([item isPinned] && item.detail != nil) {
        message = item.detail;
        title = @"Announcement";
    } else if ([item.crowded intValue] != -1 && [item.minutes intValue] != -1) {
        message = [NSString stringWithFormat:@"%@\n\nIt's %@\nAbout %i minute wait", message, [[[InfoItem getFeedbackList] objectAtIndex:[item.crowded intValue]] lowercaseString], [item.minutes intValue]];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
