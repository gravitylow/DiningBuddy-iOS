//
//  Location.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationItem
@end

@class CoordinatePair;

@interface LocationItem : NSObject

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSArray *coordinatePairs;
@property(nonatomic, retain) NSNumber *priority;

- (id) initWithName:(NSString *)nameValue
withCoordinatePairs:(NSArray *)coordinatePairsValue
       withPriority:(int)priorityValue;

- (NSString *)getName;

- (bool)isInsideLocation:(double)latitude :(double)longitude;

@end
