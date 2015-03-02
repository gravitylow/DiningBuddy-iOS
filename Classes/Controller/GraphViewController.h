//
//  GraphViewController.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabsController;

@interface GraphViewController : UIViewController <UIWebViewDelegate>

@property(nonatomic, retain) IBOutlet UIWebView *webView;
@property(nonatomic, retain) NSString *location;

@end
