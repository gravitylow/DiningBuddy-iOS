//
//  Locator.m
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "Locator.h"
#import "BackendService.h"
#import "SettingsService.h"
#import "Location.h"
#import "Api.h"

@implementation Locator

@synthesize locationsList;
@synthesize setup;

- (id)init {
    if (self = [super init]) {
        locationsList = [NSMutableArray alloc];
        setup = false;
    }
    return self;
}

- (id)initWithJson:(NSString *)json {
    if (self = [super init]) {
        self.jsonValue = json;
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        locationsList = [Api locationsFromJson:array];
        setup = true;
    }
    return self;
}

- (Location *)getLocation:(double)latitude :(double)longitude {
    NSUInteger count = [locationsList count];
    for (int i = 0; i < count; i++) {
        Location *location = locationsList[i];
        if ([location isInsideLocation:latitude :longitude]) {
            return location;
        }
    }
    return nil;
}

- (void)setLocations:(NSDictionary *)value {
    NSString *string = [value description];
    self.jsonValue = string;
    NSArray *array = [Api locationsFromJson:value];

    if ([array count] == 0) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateLocations) userInfo:nil repeats:NO];
    } else {
        locationsList = array;
        setup = true;
        [[BackendService getSettingsService] cacheLocations:string];
    }
}

- (void)updateLocations {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Api getLocationsForLocator:self];
    });
}

- (NSArray *)getLocations {
    return locationsList;
}

- (bool)isSetup {
    return setup;
}

- (NSString *)jsonValue {
    return self.jsonValue;
}

@end
