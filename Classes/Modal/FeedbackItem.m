//
//  FeedbackItem.m
//  DiningBuddy
//
//  Created by Adam Fendley on 3/2/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import "FeedbackItem.h"

@implementation FeedbackItem

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"uuid"}];
}

@end
