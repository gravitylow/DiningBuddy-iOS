//
//  Api.m
//  CNU
//
//  Created by Adam Fendley on 10/11/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import "Api.h"
#import "Location.h"
#import "Locator.h"
#import "LocationService.h"
#import "LocationInfo.h"
#import "CoordinatePair.h"

@implementation Api

NSString * const API_HOST = @"https://api.gravitydevelopment.net%@";
NSString * const API_VERSION = @"v1.0";
NSString * const API_QUERY = @"/cnu/api/%@/";
NSString * const API_USER_AGENT = @"CNU-iOS-v1";
NSString * const API_CONTENT_TYPE = @"application/json";

+(NSString *)getApiUrl {
    return [NSString stringWithFormat:API_HOST, [NSString stringWithFormat:API_QUERY, API_VERSION]];
}

+(NSString *)getApiUrlForString: (NSString *) value {
    return [NSString stringWithFormat:@"%@%@", [self getApiUrl], value];
}

+(NSArray *)locationsFromJson: (id)json {
    return [self locationsFromArray:json];
}

+(NSArray *)locationsFromArray: (NSArray *) array {
    NSMutableArray *new = [[NSMutableArray alloc] init];
    for (NSDictionary* value in array) {
        NSString *name = [value objectForKey:@"name"];
        NSArray *coordinatePairs = [value objectForKey:@"coordinatePairs"];
        NSMutableArray *newCoordinatePairs = [[NSMutableArray alloc] init];
        for (NSDictionary *pair in coordinatePairs) {
            double lat = [[pair valueForKey:@"lat"] doubleValue];
            double lon = [[pair valueForKey:@"lon"] doubleValue];
            [newCoordinatePairs addObject:[[CoordinatePair alloc] initWithDouble:lat withDouble:lon]];
        }
        NSArray *subLocations = [value objectForKey:@"subLocations"];
        
        Location *location;
        if ([subLocations count] > 0) {
            location = [[Location alloc] initWithName:name withCoordinatePairs:newCoordinatePairs withSubLocations:[self locationsFromArray:subLocations]];
        } else {
            location = [[Location alloc] initWithName:name withCoordinatePairs:newCoordinatePairs];
        }
        
        [new addObject:location];
    }
    return new;
}

+(NSArray *)infoFromJson: (id)json {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary* value in json) {
        NSString *name = [value objectForKey:@"location"];
        int people = [[value objectForKey:@"people"] integerValue];
        int crowded = [[value objectForKey:@"crowded"] integerValue];
        CrowdedRating rating = [LocationInfo getCrowdedRatingForInt:crowded];
        
        LocationInfo *info = [[LocationInfo alloc] initWithName:name withPeople:people withCrowdedRating:rating];
        [array addObject:info];
    }
    return array;
}

+(void)getLocationsForLocator: (Locator *) locator {
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"locations"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         if (data.length > 0 && error == nil) {
             id response = [NSJSONSerialization JSONObjectWithData:data
                                                            options:0
                                                              error:NULL];
             NSLog(@"Response: %@", response);
             NSArray *array = [self locationsFromJson:response];
             [locator setLocations:array];
         }
     }];
}

+(void)getInfoForService: (LocationService *) locationService {
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"info"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data.length > 0 && error == nil) {
            id response = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:NULL];
            NSArray *array = [self infoFromJson:response];
            [locationService setInfo:array];
        }
    }];
}

+(void) sendUpdateWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(Location *)location withTime:(long)time withUUID:(NSString *)uuid {
    if (location == nil) {
        //return;
    }
    NSString *json = [NSString stringWithFormat:@"{\"id\" : \"%@\", \"lat\" : %f, \"lon\" : %f, \"location\" : \"%@\", \"time\" : %li }", uuid, latitude, longitude, [location getName], time];
    NSLog(@"Update: %@", json);
}

+(void) sendFeedbackWithTarget:(NSString *)target withLocation:(Location *)location withCrowded:(int)crowded withMinutes:(int)minutes withFeedback:(NSString *)feedback withTime:(long)time withUUID:(NSString *)uuid {
    //TODO
}

@end
