//
//  APIManager.h
//  Bulletin
//
//  Created by Ryan Khalili on 2/14/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface APIManager : AFHTTPSessionManager

@property (nonatomic) BOOL eventsNeedUpdate;

+ (APIManager *)sharedManager;

+ (NSString *)serverURL;

- (void)authorizeImageGETRequest:(NSString *)urlPath
                        response:(void(^)(NSError *error, id response)) callback;

- (void)getAllEventsWithResponse:(void(^)(NSError *error, id response)) callback;

- (void)postEventWithParams:(NSDictionary *)params withImage:(UIImage *)image
                   response:(void(^)(NSError *error, id response)) callback;

- (void)getEventInfoForEventID:(NSString *)eventID
                      response:(void(^)(NSError *error, id response)) callback;

- (void)getMyEventsWithResponse:(NSString *)userID response:(void(^)(NSError *error, id response)) callback;

- (void)getEventsByCatagory:(NSString *)category response:(void(^)(NSError *error, id response)) callback;

- (void)removeEventWithEventID:(NSString *)eventID response:(void(^)(NSError *error, id response)) callback;

- (void)editEventWithParams:(NSDictionary *)params withImage:(UIImage *)image
                   response:(void(^)(NSError *error, id response)) callback;

- (void)likeEventWithEventID:(NSString *)eventID response:(void(^)(NSError *error, id response)) callback;

- (void)addNewUserWithEmail:(NSString *)email response:(void(^)(NSError *error, id response)) callback;

- (void)getUIDForEmail:(NSString *)email response:(void(^)(NSError *error, id response)) callback;

@end
