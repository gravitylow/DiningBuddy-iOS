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
#import "MenuViewController.h"
#import "FeedViewController.h"
#import "LocationMenuItem.h"
#import "LocationFeedItem.h"

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
             //NSLog(@"Response: %@", response);
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
            //NSLog(@"Response: %@", response);
            NSArray *array = [self infoFromJson:response];
            [locationService setInfo:array];
        }
    }];
}

+(NSArray *)menuFromJson: (id)json {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary* value in json) {
        NSString *startTime = [value objectForKey:@"start"];
        NSString *endTime = [value objectForKey:@"end"];
        NSString *summary = [value objectForKey:@"summary"];
        NSString *description = [value objectForKey:@"description"];
        
        LocationMenuItem *item = [[LocationMenuItem alloc] initWithStart:startTime withEnd:endTime withSummary:summary withDescription:description ];
        [array addObject:item];
    }
    
    return array;
}

+(void)getMenuForLocation:(NSString *)location forMenuController:(MenuViewController *)controller {
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:[NSString stringWithFormat:@"menus/%@", location]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data.length > 0 && error == nil) {
            id response = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:NULL];
            NSArray *array = [self menuFromJson:response];
            [controller setMenu:array];
        }
    }];
}

+(NSArray *)feedFromJson: (id)json {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary* value in json) {
        NSString *message = [value objectForKey:@"feedback"];
        int minutes = [[value objectForKey:@"minutes"] integerValue];
        int crowded = [[value objectForKey:@"crowded"] integerValue];
        long long time = [[value objectForKey:@"time"] longLongValue];
        bool pinned = [[value objectForKey:@"pinned"] boolValue];
        NSString *detail = [value objectForKey:@"detail"];
        
        LocationFeedItem *item = [[LocationFeedItem alloc] initWithMessage:message withMinutes:minutes withCrowded:crowded withTime:time withPinned:pinned withDetail:detail];
        [array addObject:item];
    }
    return array;
}

+(void)getFeedForLocation:(NSString *)location forFeedController:(FeedViewController *)controller {
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:[NSString stringWithFormat:@"feed/%@", location]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data.length > 0 && error == nil) {
            id response = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:NULL];
            NSArray *array = [self feedFromJson:response];
            [controller setFeed:array];
        }
    }];
}

+(void) sendUpdateWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(Location *)location withTime:(long long)time withUUID:(NSString *)uuid {
    if (location == nil) {
        return;
    }
    NSString *json = [NSString stringWithFormat:@"{\"id\" : \"%@\", \"lat\" : %f, \"lon\" : %f, \"location\" : \"%@\", \"time\" : %lli }", uuid, latitude, longitude, [location getName], time];
    NSLog(@"Update: %@", json);
    
    
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"update"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:API_CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
    [request setValue:API_USER_AGENT forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody: requestData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:nil];
}

+(void) sendFeedbackWithTarget:(NSString *)target withLocation:(Location *)location withCrowded:(int)crowded withMinutes:(int)minutes withFeedback:(NSString *)feedback withTime:(long long)time withUUID:(NSString *)uuid {
    if (crowded == -1 || minutes == -1) {
        return;
    }
    NSString *json = [NSString stringWithFormat:@"{\"id\" : \"%@\", \"target\" : \"%@\", \"crowded\" : %i, \"minutes\" : %i, \"feedback\" : \"%@\", \"location\" : \"%@\", \"time\" : %lli, \"pinned\" : false }", uuid, target, crowded, minutes, feedback, [location getName], time];
    NSLog(@"Feedback: %@", json);
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"feedback"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:API_CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
    [request setValue:API_USER_AGENT forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody: requestData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:nil];
}

@end
