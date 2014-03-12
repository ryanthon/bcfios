//
//  Event.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "Event.h"

@interface Event()

@property (strong, nonatomic) NSMutableArray  *categories;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation Event

+ (Event *)eventFromDictionary:(NSDictionary *)dictionary
{
    Event *event = [[Event alloc] init];
    
    event.name = [dictionary objectForKey:@"eventName"];
    event.description = [dictionary objectForKey:@"description"];
    event.latitude = [[dictionary objectForKey:@"latitude"] doubleValue];
    event.longitude = [[dictionary objectForKey:@"longitude"] doubleValue];
    
    return event;
}

- (NSArray *)getCategories
{
    return [self.categories copy];
}

- (void)addCategory:(NSString *)category
{
    [self.categories addObject:category];
}

- (void)removeCategory:(NSString *)category
{
    [self.categories removeObject:category];
}

- (NSMutableArray *)categories
{
    if( !_categories )
    {
        _categories = [[NSMutableArray alloc] init];
    }
    
    return _categories;
}

- (NSDateFormatter *)dateFormatter
{
    if( !_dateFormatter )
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    }
    
    return _dateFormatter;
}

- (NSDictionary *)getEventAsDictionary
{
    NSString *latString  = [NSString stringWithFormat:@"%f", self.latitude];
    NSString *longString = [NSString stringWithFormat:@"%f", self.longitude];
    
    return @{ @"eventName" : self.name,            @"location" : self.locationDetails,
              @"desc"      : self.description,     @"start"    : [self.dateFormatter stringFromDate:self.startDate],
              @"end"       : [self.dateFormatter stringFromDate:self.endDate],
              @"lat"       : latString,            @"long"     : longString };
}

@end