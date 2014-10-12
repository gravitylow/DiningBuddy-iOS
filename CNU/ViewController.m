//
//  ViewController.m
//  CNU
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize regattasView;
@synthesize regattasTitle;
@synthesize regattasInfo;
@synthesize commonsView;
@synthesize commonsTitle;
@synthesize commonsInfo;
@synthesize einsteinsView;
@synthesize einsteinsTitle;
@synthesize einsteinsInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CNU Dining";
    
    for (int i=1;i<=3;i++) {
        UIImageView *view = (UIImageView *)[self.view viewWithTag:i];
        view.contentMode = UIViewContentModeScaleToFill;
        view.center = self.view.center;
        
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 10.0;
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [[UIColor grayColor] CGColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"Regattas"]) {
        LocationViewController *c = [segue destinationViewController];
        c.location = @"Regattas";
        c.label = @"Regattas";
        c.photo = @"regattas_full.jpg";
    } else if ([segue.identifier isEqualToString:@"Commons"]) {
        LocationViewController *c = [segue destinationViewController];
        c.location = @"Commons";
        c.label = @"The Commons";
        c.photo = @"commons_full.jpg";
    } else if ([segue.identifier isEqualToString:@"Einsteins"]) {
        LocationViewController *c = [segue destinationViewController];
        c.location = @"Einsteins";
        c.label = @"Einstein's";
        c.photo = @"einsteins_full.jpg";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
