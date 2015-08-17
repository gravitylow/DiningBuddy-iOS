//
//  LocationMenuItem.h
//  DiningBuddy
//
//  Created by Adam Fendley on 10/19/14.
//  Copyright (c) 2014 Adam Fendley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONKeyMapper.h>
#import "JSONModel.h"

@interface MenuItem : JSONModel

@property(nonatomic, retain) NSString *start;
@property(nonatomic, retain) NSString *end;
@property(nonatomic, retain) NSString *summary;
@property(nonatomic, retain) NSString *desc;

@end
