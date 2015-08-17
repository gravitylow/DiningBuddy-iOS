//
//  API.m
//  DiningBuddy
//
//  Created by Adam Fendley on 3/2/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import "API.h"
#import "JSONHTTPClient.h"
#import "AlertItem.h"
#import "LocationCollection.h"
#import "InfoItem.h"
#import "FeedItem.h"
#import "MenuItem.h"
#import "UpdateItem.h"
#import "FeedbackItem.h"

static NSString *const API_URL = @"https://api.gravitydevelopment.net/cnu/api/v1.0";
static NSString *const API_CONTENT_TYPE = @"application/json";
static NSString *API_USER_AGENT = @"DiningBuddy-iOS";

@implementation API

+ (void)initialize {
    if (self == [API class]) {
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        API_USER_AGENT = [NSString stringWithFormat:@"%@-v%@", API_USER_AGENT, version];

        [[JSONHTTPClient requestHeaders] setValue:API_USER_AGENT forKey:@"User-Agent"];
        [[JSONHTTPClient requestHeaders] setValue:API_CONTENT_TYPE forKey:@"Content-Type"];
    }
}


+ (void)getAlerts:(void (^)(NSArray *alerts))finishBlock {
    NSString *string = [NSString stringWithFormat:@"%@/alerts/", API_URL];
    [JSONHTTPClient getJSONFromURLWithString:string completion:^(id json, JSONModelError *err) {
        NSError *error = nil;
        NSMutableArray *array = [AlertItem arrayOfModelsFromDictionaries:json error:&error];
        finishBlock(array);
    }];
}

+ (void)getLocations:(void (^)(NSArray *locations))finishBlock {
    NSString *string = [NSString stringWithFormat:@"%@/locations/", API_URL];
    [JSONHTTPClient getJSONFromURLWithString:string completion:^(id json, JSONModelError *err) {
        LocationCollection *collection = [[LocationCollection alloc] initWithJson:json];
        finishBlock(collection.locations);
    }];
}

+ (void)getInfo:(void (^)(NSArray *info))finishBlock {
    NSString *string = [NSString stringWithFormat:@"%@/info/", API_URL];
    [JSONHTTPClient getJSONFromURLWithString:string completion:^(id json, JSONModelError *err) {
        NSError *error = nil;
        NSMutableArray *array = [InfoItem arrayOfModelsFromDictionaries:json error:&error];
        finishBlock(array);
    }];
}

+ (void)getInfoForLocationName:(NSString *)location :(void (^)(InfoItem *info))finishBlock {
    NSString *string = [NSString stringWithFormat:@"%@/info/%@/", API_URL, location];
    [JSONHTTPClient getJSONFromURLWithString:string completion:^(id json, JSONModelError *err) {
        NSError *error = nil;
        InfoItem *item = [[InfoItem alloc] initWithString:json error:&error];
        finishBlock(item);
    }];
}

+ (void)getMenuForLocationName:(NSString *)location :(void (^)(NSArray *menu))finishBlock {
    NSString *string = [NSString stringWithFormat:@"%@/menus/%@", API_URL, location];
    [JSONHTTPClient getJSONFromURLWithString:string completion:^(id json, JSONModelError *err) {
        NSError *error = nil;
        NSMutableArray *array = [MenuItem arrayOfModelsFromDictionaries:json error:&error];
        finishBlock(array);
    }];
}

+ (void)getAllMenus:(void (^)(NSArray *regattas, NSArray *commons))finishBlock {
    // We need these calls to be in sync

    NSString *location = @"Regattas";
    NSString *string = [NSString stringWithFormat:@"%@/menus/%@/", API_URL, location];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

    NSMutableArray *regattas = [MenuItem arrayOfModelsFromDictionaries:json error:&error];

    location = @"Commons";
    string = [NSString stringWithFormat:@"%@/menus/%@/", API_URL, location];
    url = [NSURL URLWithString:string];
    urlRequest = [NSURLRequest requestWithURL:url];
    response = nil;
    error = nil;
    data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

    NSMutableArray *commons = [MenuItem arrayOfModelsFromDictionaries:json error:&error];

    finishBlock(regattas, commons);
}

+ (void)getFeedForLocationName:(NSString *)location :(void (^)(NSArray *feed))finishBlock {
    NSString *string = [NSString stringWithFormat:@"%@/feed/%@/", API_URL, location];
    //NSLog(@"Loading feed from %@", string);
    [JSONHTTPClient getJSONFromURLWithString:string completion:^(id json, JSONModelError *err) {
        NSError *error = [[NSError alloc] init];
        NSMutableArray *array = [FeedItem arrayOfModelsFromDictionaries:json error:&error];
        finishBlock(array);
    }];
}

+ (void)sendUpdate:(UpdateItem *)update {
    NSString *string = [NSString stringWithFormat:@"%@/update/", API_URL];
    NSString *json = [update toJSONString];
    NSLog(@"Posting Update JSON: %@", json);
    [JSONHTTPClient postJSONFromURLWithString:string bodyString:json completion:^(id json, JSONModelError *err) {
        NSLog(@"Response: %@", json);
    }];
}

+ (void)sendFeedback:(FeedbackItem *)feedback {
    NSString *string = [NSString stringWithFormat:@"%@/feedback/", API_URL];
    NSString *json = [feedback toJSONString];
    //NSLog(@"Posting Feedback JSON: %@", json);
    [JSONHTTPClient postJSONFromURLWithString:string bodyString:json completion:^(id json, JSONModelError *err) {
        NSLog(@"Response: %@", json);
    }];
}

@end
