//
//  Event.h
//  Bulletin
//
//  Created by Ryan Khalili on 3/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;

- (void)addCategory:(NSString *)category;
- (void)removeCategory:(NSString *)category;
- (NSArray *)getCategories;

@end