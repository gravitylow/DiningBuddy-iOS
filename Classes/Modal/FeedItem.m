//
//  LocationFeedItem.m
//  DiningBuddy
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"uuid"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"detail"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isPinned {
    return [self.pinned integerValue] == [[NSNumber numberWithBool:YES] integerValue];
}

@end
