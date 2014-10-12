//
//  Fence.h
//  CNU
//
//  Created by Adam Fendley on 9/13/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Fence;
@interface Fence : NSObject

@property (nonatomic) double *effectiveMinLat;
@property (nonatomic) double *effectiveMaxLat;
@property (nonatomic) double *effectiveMinLong;
@property (nonatomic) double *effectiveMaxLong;
@property (nonatomic) NSInteger size;

-(id)init;
-(id)initWithBounds:(double *)effectiveMinLat :(double *)effectiveMaxLat :(double *)effectiveMinLong :(double *)effectiveMaxLong;
-(bool)addBound:(double *)latitude :(double *)longitude;
-(bool)isInsideFence:(double *)latitude :(double *)longitude;
-(NSString *)jsonValue;
@end
