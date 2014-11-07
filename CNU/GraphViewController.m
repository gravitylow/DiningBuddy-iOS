//
//  GraphViewController.m
//  CNU
//
//  Created by Adam Fendley on 10/16/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "GraphViewController.h"
#import "TabsController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loading graph");
    
    TabsController *parent = (TabsController *)self.tabBarController;
    self.location = parent.location;
    
    NSLog(@"Parent location: %@", parent.location);
    NSString *urlAddress = @"https://api.gravitydevelopment.net/cnu/api/v1.0/graphs/";
    urlAddress = [urlAddress stringByAppendingString:self.location];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    NSLog(@"Done loading graph");
    [self.webView setScalesPageToFit:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.navigationController.navigationBar.translucent == YES) {
        //webView.scrollView.contentOffset = CGPointMake(webView.frame.origin.x, webView.frame.origin.y + 100);
    }
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:webView.scrollView.contentSize];
    frame.size = fittingSize;
    webView.frame = frame;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

@end
