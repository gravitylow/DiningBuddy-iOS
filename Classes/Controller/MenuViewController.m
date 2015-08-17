//
//  MenuViewController.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItem.h"
#import "API.h"

@implementation MenuViewController

@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = nil;
    [self getMenu];
}

- (void)getMenu {
    [API getMenuForLocationName:self.location :^(NSArray *menu) {
        self.data = menu;
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    MenuItem *item = data[indexPath.row];
    
    cell.textLabel.text = item.summary;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", item.start, item.end];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.data) {
        if ([self.data count] > 1) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.tableView.backgroundView = nil;
            return 1;
        } else {
            [self setTableMessage:@"Nothing being served today."];
        }
    } else {
        [self setTableMessage:@"Loading..."];
    }
    return 0;
}

-(void)setTableMessage:(NSString *)message {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    messageLabel.text = message;
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel sizeToFit];
    
    self.tableView.backgroundView = messageLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem *item = data[indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item.summary
                                                    message:item.desc
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
