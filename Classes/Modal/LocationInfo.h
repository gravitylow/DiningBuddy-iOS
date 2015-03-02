//
//  LocationInfo.h
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

typedef enum {
    NOT_CROWDED,
    SOMEWHAT_CROWDED,
    CROWDED
} CrowdedRating;

@interface LocationInfo : NSObject

@property(nonatomic, retain) NSString *location;
@property(nonatomic) int people;
@property(nonatomic) CrowdedRating crowdedRating;

+ (NSArray *)getFeedbackList;

+ (CrowdedRating)getCrowdedRatingForInt:(int)value;

+ (UIColor *)getColorForCrowdedRating:(CrowdedRating)value;

- (id)initWithName:(NSString *)name;

- (id)initWithName:(NSString *)name
        withPeople:(int)number
 withCrowdedRating:(CrowdedRating)rating;

- (NSString *)getLocation;

- (int)getPeople;

- (CrowdedRating)getCrowdedRating;
@end