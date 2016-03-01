//
//  AppDelegate.m
//  DiningBuddy
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "AppDelegate.h"
#import "BackendService.h"
#import "ViewController.h"
#import "LocationViewController.h"
#import "TabsController.h"
#import "LocationItem.h"
#import "InfoItem.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    NSDictionary *userDefaultsDefaults = @{@"pref_wifi_only" : @false,
                                           @"pref_notify_favorites" : @false,
                                           @"pref_favorites" : @"Tater Tots,Tender Tuesday,Pulled Pork",
                                           @"pref_alerts_read" : [NSArray array],
                                           @"pref_last_favorite_fetch" : @(-1),
                                           @"pref_last_feedback_regattas" : @(-1),
                                           @"pref_last_feedback_einsteins" :
                                               @"pref_last_feedback_commons"};
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
    [[BackendService alloc] init];
    [BackendService showAlerts];
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Background fetch");
    [mainController fetchNewDataWithCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);
    }];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL succeeded))completionHandler {
    if ([shortcutItem.type  isEqual:@"net.gravitydevelopment.cnu.openmenu"]) {
        NSDictionary <NSString *, id<NSSecureCoding>> *userInfo = shortcutItem.userInfo;
        NSString *location = (NSString *)userInfo[@"location"];
        shortcutActionLocationTab = TAB_LOCATION_MENU;
        
        if (mainController != nil && mainControllerActive) {
            [mainController performSegueWithIdentifier:location sender:mainController];
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *main = [storyboard instantiateViewControllerWithIdentifier:@"main"];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:main animated:NO completion:^{
                [mainController performSegueWithIdentifier:location sender:mainController];
            }];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)registerMainController:(ViewController *)viewController {
    mainController = viewController;
    mainControllerActive = TRUE;
}

+ (void)registerLocationController:(LocationViewController *)locationViewController {
    locationController = locationViewController;
    if (shortcutActionLocationTab != -1) {
        UITabBarController *tabs = locationController.tabs;
        tabs.selectedIndex = shortcutActionLocationTab;
        shortcutActionLocationTab = -1;
    }
    mainControllerActive = TRUE;
}

+ (void)unregisterMainController {
    mainControllerActive = FALSE;
}

+ (void)unregisterLocationController {
    locationControllerActive = FALSE;
}

+ (void)updateInfo:(NSArray *)info {
    InfoItem *regattasInfo = nil;
    InfoItem *commonsInfo = nil;
    InfoItem *einsteinsInfo = nil;
    NSUInteger count = [info count];
    if (count > 0) {
        for (int i = 0; i < count; i++) {
            InfoItem *val = (InfoItem *) info[i];
            if ([[val getLocation] isEqualToString:@"Regattas"]) {
                regattasInfo = val;
            }
            if ([[val getLocation] isEqualToString:@"Commons"]) {
                commonsInfo = val;
            }
            if ([[val getLocation] isEqualToString:@"Einsteins"]) {
                einsteinsInfo = val;
            }
        }
    }
    if (!regattasInfo) {
        regattasInfo = [[InfoItem alloc] initWithName:@"Regattas"];
    }
    if (!commonsInfo) {
        commonsInfo = [[InfoItem alloc] initWithName:@"Commons"];
    }
    if (!einsteinsInfo) {
        einsteinsInfo = [[InfoItem alloc] initWithName:@"Einsteins"];
    }
    if (mainController != nil && mainControllerActive) {
        [mainController updateInfoWithRegattas:regattasInfo withCommons:commonsInfo withEinsteins:einsteinsInfo];
    }
    if (locationController != nil && locationControllerActive) {
        [locationController updateInfoWithRegattas:regattasInfo withCommons:commonsInfo withEinsteins:einsteinsInfo];
    }
}

+ (void)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(LocationItem *)location {
    if (mainController != nil && mainControllerActive) {
        [mainController updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
    }
    if (locationController != nil && locationControllerActive) {
        [locationController updateLocationWithLatitude:latitude withLongitude:longitude withLocation:location];
    }
}

@end
