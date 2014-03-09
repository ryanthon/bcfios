//
//  Event.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "Event.h"

@interface Event()

@property (strong, nonatomic) NSMutableArray *categories;

@end

@implementation Event

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

@end