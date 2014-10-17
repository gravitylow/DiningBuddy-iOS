//
//  Locator.m
//  CNU
//
//  Created by Adam Fendley on 10/2/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "Locator.h"
#import "SettingsService.h"
#import "Location.h"
#import "Api.h"

@implementation Locator

@synthesize locations;
@synthesize setup;

- (id) init {
    if (self = [super init]) {
        locations = [NSMutableArray alloc];
        setup = false;
    }
    return self;
}
- (id) initWithJson: (NSString *) json {
    if (self = [super init]) {
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        locations = [Api locationsFromJson:array];
        setup = true;
        [self getAllLocations];
    }
    return self;
}
- (Location *) getLocation: (double) latitude : (double) longitude {
    NSUInteger count = [locations count];
    for (int i=0;i<count;i++) {
        Location *val = [locations objectAtIndex:i];
        Location *applicable = [Locator getApplicableLocation:val :latitude :longitude];
        if (applicable != nil) {
            return applicable;
        }
    }
    return nil;
}
+ (Location *) getApplicableLocation: (Location *) base : (double) latitude : (double) longitude {
    if (![base hasSubLocations]) {
        if ([base isInsideLocation:latitude :longitude]) {
            return base;
        } else {
            return nil;
        }
    }
    
    NSUInteger count = [[base getSubLocations] count];
    for (int i=0;i<count;i++) {
        Location *value = (Location *)[[base getSubLocations] objectAtIndex:i];
        Location *applicable = [Locator getApplicableLocation:value :latitude :longitude];
        if (applicable != nil) {
            return applicable;
        }
    }
    return [base isInsideLocation:latitude :longitude] ? base : nil;
}
- (void) setLocations: (NSArray *)array {
    if ([array count] == 0) {
        NSLog(@"Detected no locations recieved, trying again soon...");
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateLocations) userInfo:nil repeats:NO];
    } else {
        NSLog(@"Locations set to size %i", [array count]);
        locations = array;
        setup = true;
    }
}

- (void) updateLocations {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Updating locations..");
        [Api getLocationsForLocator:self];
    });
}
- (void) postLocation: (double) latitude : (double) longitude : (Location *) location : (NSString *) uuid {
    [Api sendUpdateWithLatitude:latitude withLongitude:longitude withLocation:location withTime:[SettingsService getTime] withUUID:uuid];
}
- (NSArray *) getLocations {
    return locations;
}
- (NSArray *) getAllLocations {
    NSLog(@"Get all locatons");
    return [self recursiveGetLocations:[NSMutableArray alloc] :locations];
}
- (NSArray *) recursiveGetLocations: (NSMutableArray *) build : (NSArray *) locs {
    NSUInteger count = [locs count];
    for (int i=0;i<count;i++) {
        Location *val = [locations objectAtIndex:i];
        NSLog(@"loc: %@", [val getName]);
        [build addObject:val];
        if ([val hasSubLocations]) {
            [self recursiveGetLocations:build :[val getSubLocations]];
        }
    }
    return build;
}
- (bool) isSetup {
    return setup;
}
- (NSString *) jsonValue {
    NSMutableString *value = [NSMutableString alloc];
    [value appendString:@"["];
    NSUInteger count = [locations count];
    if (count > 0) {
        for(int i=0;i<count;i++) {
            Location *loc = [locations objectAtIndex:i];
            [value appendString:[loc jsonValue]];
            [value appendString:@","];
        }
        [value deleteCharactersInRange:NSMakeRange([value length]-1, 1)];
    }
    return value;
}

@end
