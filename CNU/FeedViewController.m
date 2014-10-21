//
//  MenuViewController.m
//  CNU
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "FeedViewController.h"
#import "LocationFeedItem.h"
#import "Api.h"
#import "SettingsService.h"

@implementation FeedViewController

@synthesize data;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[NSArray alloc]init];
    [Api getFeedForLocation:self.location forFeedController:self];
    NSLog(@"Requesting feed");
}

-(void)setFeed:(NSArray *)array {
    NSLog(@"Feed set");
    NSLog(@"Array size: %i", [array count]);
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (LocationFeedItem *item in array) {
        if (item.pinned) {
            [temp insertObject:item atIndex:0];
        } else {
            [temp addObject:item];
        }
    }
    self.data = temp;
    NSLog(@"Temp size: %i", [temp count]);
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    LocationFeedItem *item = [data objectAtIndex:indexPath.row];
    
    if (item.pinned) {
        cell.backgroundColor = [UIColor colorWithRed:0.165 green:0.69 blue:0.506 alpha:1]; /*#2ab081*/
    }
    
    NSLog(@"Item time: %li", item.time);
    NSLog(@"Current time: %li", [SettingsService getTime]);
    NSLog(@"Message: %@", item.message);
    cell.textLabel.text = item.message;
    cell.detailTextLabel.text = [self minutesAgo:item.time];
    return cell;
}

-(NSString *) minutesAgo:(long)time {
    long diff = [SettingsService getTime] - time;
    double mins = (diff / 1000) / 60;
    if (mins < 1) {
        return @"< 1 minute ago";
    } else if (mins >= 1 && mins < 2) {
        return @"1 minute ago";
    } else {
        return [NSString stringWithFormat:@"%i minutes ago", (int)mins];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationFeedItem *item = [data objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback"
                                                    message:item.message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
