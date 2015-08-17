//
//  LocationCollection.h
//  DiningBuddy
//
//  Created by Adam Fendley on 3/2/15.
//  Copyright (c) 2015 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationItem.h"

@interface LocationCollection : NSObject

@property(strong, nonatomic) NSArray <LocationItem> *locations;

- (id)initWithJson:(NSString *)string;

@end
