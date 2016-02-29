//
//  AppDelegate.h
//  DiningBuddy
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ViewController;
@class LocationViewController;
@class TabsController;
@class BackendService;
@class SettingsService;
@class LocationItem;
@class InfoItem;

static ViewController *mainController = nil;
static bool mainControllerActive = FALSE;
static LocationViewController *locationController = nil;
static bool locationControllerActive = FALSE;
static int shortcutActionLocationTab = -1;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

+ (void)registerMainController:(ViewController *)viewController;

+ (void)registerLocationController:(LocationViewController *)locationViewController;

+ (void)unregisterMainController;

+ (void)unregisterLocationController;

+ (void)updateInfo:(NSArray *)info;

+ (void)updateLocationWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(LocationItem *)location;

@end

