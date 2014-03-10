//
//  Event.h
//  Bulletin
//
//  Created by Ryan Khalili on 3/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) UIImage  *image;
@property (strong, nonatomic) NSDate   *startDate;
@property (strong, nonatomic) NSDate   *endDate;
@property (strong, nonatomic) NSString *locationDetails;

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;

- (void)addCategory:(NSString *)category;
- (void)removeCategory:(NSString *)category;
- (NSArray *)getCategories;

@end