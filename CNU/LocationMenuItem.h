//
//  LocationMenuItem.h
//  CNU
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationMenuItem : NSObject

@property(nonatomic, retain) NSString *startTime;
@property(nonatomic, retain) NSString *endTime;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSString *desc;

-(id) initWithStart:(NSString *)start withEnd:(NSString *)end withSummary:(NSString *)sum withDescription:(NSString *)des;

@end
