//
//  TabsController.h
//  CNU
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationInfo;
@class FeedbackViewController;
@class GraphViewController;

@interface TabsController : UITabBarController <UITabBarDelegate>

@property(nonatomic, retain) NSString  *location;
@property(nonatomic, retain) NSString  *label;
@property(nonatomic, retain) NSString  *photo;
@property(nonatomic, retain) LocationInfo *info;

@end
