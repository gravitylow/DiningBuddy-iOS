//
//  MenuViewController.m
//  CNU
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "MenuViewController.h"
#import "LocationMenuItem.h"
#import "Api.h"

@implementation MenuViewController

@synthesize data;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[NSArray alloc]init];
    [Api getMenuForLocation:self.location forMenuController:self];
}

-(void)setMenu:(NSArray *)array {
    self.data = array;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    LocationMenuItem *item = [data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.summary;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", item.startTime, item.endTime];
    return cell;
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
        
        messageLabel.text = @"Loading...";
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
    LocationMenuItem *item = [data objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item.summary
                                                    message:item.desc
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
