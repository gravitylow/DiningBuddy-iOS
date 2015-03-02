//
//  ViewController.m
//  CNU
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LocationViewController.h"
#import "BannerViewController.h"
#import "Location.h"
#import "LocationInfo.h"
#import "BackendService.h"
#import "LocationService.h"
#import "SettingsService.h"
#import "CustomViewCell.h"
#import "Api.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize regattasView;
@synthesize commonsView;
@synthesize einsteinsView;

@synthesize lastRegattasInfo;
@synthesize lastCommonsInfo;
@synthesize lastEinsteinsInfo;

@synthesize regattasHasBadge;
@synthesize commonsHasBadge;
@synthesize einsteinsHasBadge;

@synthesize refreshControl;

@synthesize appSettingsViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"DiningBuddy";

    refreshControl = [[UIRefreshControl alloc] init];
    [self.scrollView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
    [[BackendService getLocationService] requestFullUpdate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationViewController *c = [segue destinationViewController];
    if ([segue.identifier hasSuffix:@"Regattas"]) {
        c.location = @"Regattas";
        c.label = @"Regattas";
        c.photo = @"regattas_full.jpg";
        c.hasBadge = regattasHasBadge;
        if (lastRegattasInfo) {
            c.info = lastRegattasInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            regattasView = (BannerViewController *) [segue destinationViewController];
        }
    } else if ([segue.identifier hasSuffix:@"Commons"]) {
        c.location = @"Commons";
        c.label = @"The Commons";
        c.photo = @"commons_full.jpg";
        c.hasBadge = commonsHasBadge;
        NSLog(@"Commons info: %@", lastCommonsInfo);
        if (lastCommonsInfo) {
            NSLog(@"Passed");
            c.info = lastCommonsInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            commonsView = (BannerViewController *) [segue destinationViewController];
        }
    } else if ([segue.identifier hasSuffix:@"Einsteins"]) {
        c.location = @"Einsteins";
        c.label = @"Einstein's";
        c.photo = @"einsteins_full.jpg";
        c.hasBadge = einsteinsHasBadge;
        if (lastEinsteinsInfo) {
            c.info = lastEinsteinsInfo;
        }
        if ([segue.identifier hasPrefix:@"embed"]) {
            einsteinsView = (BannerViewController *) [segue destinationViewController];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [AppDelegate registerMainController:self];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [AppDelegate unregisterMainController];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)updateInfoWithRegattas:(LocationInfo *)regattas withCommons:(LocationInfo *)commons withEinsteins:(LocationInfo *)einsteins {
    lastRegattasInfo = regattas;
    lastCommonsInfo = commons;
    lastEinsteinsInfo = einsteins;
    [regattasView updateViewWithLocationInfo:regattas];
    [commonsView updateViewWithLocationInfo:commons];
    [einsteinsView updateViewWithLocationInfo:einsteins];

    if ([refreshControl isRefreshing]) {
        [refreshControl endRefreshing];
    }

}

- (void)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(Location *)location {
    //NSLog(@"Updating all embeded views...");
    regattasHasBadge = [regattasView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
    commonsHasBadge = [commonsView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
    einsteinsHasBadge = [einsteinsView updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
}

- (IASKAppSettingsViewController *)appSettingsViewController {
    if (!appSettingsViewController) {
        appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
        appSettingsViewController.delegate = self;
    }
    return appSettingsViewController;
}

- (IBAction)openSettings {
    [self appSettingsViewController];
    appSettingsViewController.showCreditsFooter = NO;
    appSettingsViewController.showDoneButton = NO;
    appSettingsViewController.navigationItem.rightBarButtonItem = nil;
    [self.navigationController pushViewController:appSettingsViewController animated:YES];
}

- (void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([[BackendService getSettingsService] getNotifyFavorites]) {
        NSDate *now = [NSDate date];
        NSCalendar *myCalendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [myCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                     fromDate:[NSDate date]];
        [components setHour:6];
        [components setMinute:0];
        [components setSecond:0];
        NSDate *todayAt5 = [myCalendar dateFromComponents:components];
        if ([now compare:todayAt5] == NSOrderedDescending) {
            NSLog(@"It's after 5...");
            long long time = [SettingsService getTime];
            long long lastFetch = [[BackendService getSettingsService] getLastFavoriteFetch];
            NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:(lastFetch / 1000.0)];
            if (lastFetch == 0 || [lastDate compare:todayAt5] == NSOrderedAscending) {
                NSLog(@"Last update was before 5 today. Fetching now.");
                [[BackendService getSettingsService] setLastFavoriteFetch:time];
                [Api getLatestMenus];
                completionHandler(UIBackgroundFetchResultNewData);
                return;
            }
        }
    }
    completionHandler(UIBackgroundFetchResultNoData);
}

- (CGFloat)settingsViewController:(id <IASKViewController>)settingsViewController
                        tableView:(UITableView *)tableView
        heightForHeaderForSection:(NSInteger)section {
    NSString *key = [[appSettingsViewController settingsReader] keyForSection:section];
    if ([key isEqualToString:@"IASKCustomHeaderStyle"]) {
        return 55.f;
    }
    return 0;
}

- (UIView *)settingsViewController:(id <IASKViewController>)settingsViewController
                         tableView:(UITableView *)tableView
           viewForHeaderForSection:(NSInteger)section {
    NSString *key = [[appSettingsViewController settingsReader] keyForSection:section];
    if ([key isEqualToString:@"IASKCustomHeaderStyle"]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1);
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:16.f];
        //figure out the title from settingsbundle
        label.text = [settingsViewController.settingsReader titleForSection:section];
        return label;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForSpecifier:(IASKSpecifier *)specifier {
    if ([specifier.key isEqualToString:@"customCell"]) {
        return 44 * 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSpecifier:(IASKSpecifier *)specifier {
    [tableView dequeueReusableCellWithIdentifier:specifier.key];

    CustomViewCell *cell = (CustomViewCell *) [tableView dequeueReusableCellWithIdentifier:specifier.key];
    if (!cell) {
        cell = (CustomViewCell *) [[NSBundle mainBundle] loadNibNamed:@"CustomViewCell"
                                                                owner:self
                                                              options:nil][0];
    }
    cell.textView.text = [[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] != nil ?
            [[NSUserDefaults standardUserDefaults] objectForKey:specifier.key] : [specifier defaultStringValue];
    //cell.textView.delegate = self;
    [cell setNeedsLayout];
    return cell;
    return nil;
}

@end
