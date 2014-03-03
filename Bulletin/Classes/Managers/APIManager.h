//
//  APIManager.h
//  Bulletin
//
//  Created by Ryan Khalili on 2/14/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

@property (nonatomic) BOOL isLoggedIn;
@property (strong, nonatomic) NSString *token_ID;

@end
