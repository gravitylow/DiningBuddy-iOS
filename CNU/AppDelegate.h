//
//  AppDelegate.h
//  CNU
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ViewController;
@class LocationViewController;
@class BackendService;

static ViewController *mainController = nil;
static LocationViewController *locationController = nil;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, retain) BackendService *backendService;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (void)registerMainController: (ViewController *)viewController;
+ (void)registerLocationController: (LocationViewController *)locationViewController;
+ (void)unregisterMainController;
+ (void)unregisterLocationController;
+ (void)updateInfo: (NSArray *)info;

@end

