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
#import "SettingsService.h"
#import "LocationService.h"
#import "LocationInfo.h"
#import "CoordinatePair.h"
#import "MenuViewController.h"
#import "FeedViewController.h"
#import "LocationMenuItem.h"
#import "LocationFeedItem.h"
#import "AlertItem.h"

@implementation Api

NSString * const API_HOST = @"https://api.gravitydevelopment.net%@";
NSString * const API_VERSION = @"v1.0";
NSString * const API_QUERY = @"/cnu/api/%@/";
NSString * const API_CONTENT_TYPE = @"application/json";

static NSString *API_USER_AGENT = @"CNU-iOS";

+ (void) initialize {
    if (self == [Api class]) {
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        API_USER_AGENT = [NSString stringWithFormat:@"%@-v%@", API_USER_AGENT, version];
    }
}

+(NSString *)getApiUrl {
    return [NSString stringWithFormat:API_HOST, [NSString stringWithFormat:API_QUERY, API_VERSION]];
}

+(NSString *)getApiUrlForString: (NSString *) value {
    return [NSString stringWithFormat:@"%@%@", [self getApiUrl], value];
}

+(void)getLocationsForLocator: (Locator *) locator {
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"locations/"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data.length > 0 && error == nil) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:NULL];
            [locator setLocations:response];
        }
    }];
}

+(NSArray *)locationsFromJson: (id) json {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSArray *array = [json objectForKey:@"features"];
    for (NSDictionary* value in array) {
        id properties = [value objectForKey:@"properties"];
        id geometry = [value objectForKey:@"geometry"];
        
        NSString *name = [properties objectForKey:@"name"];
        NSInteger priority = [[properties objectForKey:@"priority"] integerValue];
        
        NSArray *coordinates = [[geometry objectForKey:@"coordinates"] objectAtIndex:0];
        NSMutableArray *coordinatePairs = [[NSMutableArray alloc] init];
        for (NSArray *value in coordinates) {
            double longitude = [[value objectAtIndex:0] doubleValue];
            double latitude = [[value objectAtIndex:1] doubleValue];
            [coordinatePairs addObject:[[CoordinatePair alloc] initWithDouble:latitude withDouble:longitude]];
        }
        [list addObject:[[Location alloc] initWithName:name withCoordinatePairs:coordinatePairs withPriority:priority]];
    }
    return list;
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

+(void)getInfoForService: (LocationService *) locationService {
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"info/"]];
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
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:[NSString stringWithFormat:@"menus/%@/", location]]];
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
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:[NSString stringWithFormat:@"feed/%@/", location]]];
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

+(void) sendUpdateWithLatitude:(double)latitude withLongitude:(double)longitude withLocation:(Location *)location withTime:(long long)time withUUID:(NSString *)uuid{
    if (location == nil) {
        return;
    }
    NSString *json = [NSString stringWithFormat:@"{\"id\" : \"%@\", \"lat\" : %f, \"lon\" : %f, \"location\" : \"%@\", \"send_time\" : %lli }", uuid, latitude, longitude, [location getName], time];
    NSLog(@"Update: %@", json);
    
    
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"update/"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:API_CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
    [request setValue:API_USER_AGENT forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody: requestData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //[[UIApplication sharedApplication] endBackgroundTask:bgTask];
    }];
}

+(void) sendFeedbackWithTarget:(NSString *)target withLocation:(Location *)location withCrowded:(int)crowded withMinutes:(int)minutes withFeedback:(NSString *)feedback withTime:(long long)time withUUID:(NSString *)uuid {
    if (crowded == -1 || minutes == -1) {
        return;
    }
    NSString *json = [NSString stringWithFormat:@"{\"id\" : \"%@\", \"target\" : \"%@\", \"crowded\" : %i, \"minutes\" : %i, \"feedback\" : \"%@\", \"location\" : \"%@\", \"send_time\" : %lli }", uuid, target, crowded, minutes, feedback, [location getName], time];
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"feedback/"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:API_CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
    [request setValue:API_USER_AGENT forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody: requestData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:nil];
}

+(void)showAlerts :(SettingsService *)settings {
    NSURL *url = [NSURL URLWithString:[self getApiUrlForString:@"alerts/"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data.length > 0 && error == nil) {
            id response = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:NULL];
            NSArray *array = [self alertsFromJson:response];
            for (AlertItem *item in array) {
                if (![settings isAlertRead:item.message]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item.title
                                                                    message:item.message
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [settings setAlertRead:item.message];
                }
            }
        }
    }];
}

+(NSArray *)alertsFromJson: (id)json {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary* value in json) {
        NSString *message = [value objectForKey:@"message"];
        NSString *title = [value objectForKey:@"title"];
        NSString *targetOS = [value objectForKey:@"target_os"];
        NSString *targetVersion = [value objectForKey:@"target_version"];
        long long targetTimeMin = [[value objectForKey:@"target_time_min"] integerValue];
        long long targetTimeMax = [[value objectForKey:@"target_time_max"] integerValue];
        AlertItem *item = [[AlertItem alloc]init];
        item.message = message;
        item.title = title;
        item.targetOS = targetOS;
        item.targetVersion = targetVersion;
        item.targetTimeMin = targetTimeMin;
        item.targetTimeMax = targetTimeMax;
        
        if ([item isApplicable]) {
            [array addObject:item];
        }
    }
    return array;
}

@end
