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

@synthesize webView, location;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loading graph");
    TabsController *parent = (TabsController *)self.tabBarController;
    self.location = parent.location;
    NSString *urlAddress = @"https://api.gravitydevelopment.net/cnu/api/v1.0/graphs/";
    urlAddress = [urlAddress stringByAppendingString:location];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    NSLog(@"Done loading graph");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    /*CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = rw;
    webView.scrollView.maximumZoomScale = rw;
    webView.scrollView.zoomScale = rw;*/
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

@end
