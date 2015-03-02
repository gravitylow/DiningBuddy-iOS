//
//  Location.h
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoordinatePair;

@interface LocationItem : NSObject

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSArray *coordinatePairs;
@property(nonatomic) NSInteger priority;

- (id) initWithName:(NSString *)nameValue
withCoordinatePairs:(NSArray *)coordinatePairsValue
       withPriority:(NSInteger)priorityValue;

- (NSString *)getName;

- (bool)isInsideLocation:(double)latitude :(double)longitude;

@end
