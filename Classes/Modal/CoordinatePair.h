//
//  CoordinatePair.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinatePair : NSObject

@property(nonatomic, retain) NSNumber *latitude;
@property(nonatomic, retain) NSNumber *longitude;

- (id)initWithDouble:(double)lat
          withDouble:(double)lon;

- (double)getLatitude;

- (double)getLongitude;

- (NSString *)jsonValue;

@end
