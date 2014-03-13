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

+ (APIManager *)sharedManager;

+ (NSString *)serverURL;

- (void)authorizeGETrequest:(NSString *)urlPath
        additionalParamters:(NSDictionary *)params
                   response:(void(^)(NSError *error, id response)) callback;

- (void)authorizePOSTrequest:(NSString *)urlPath
         additionalParamters:(NSDictionary *)params
                    response:(void(^)(NSError *error, id response)) callback;

- (void)authorizePOSTrequest:(NSString *)urlPath
                    forImage:(UIImage *)image
                    response:(void(^)(NSError *error, id response)) callback;

- (void)authorizeImageGETRequest:(NSString *)urlPath
                        response:(void(^)(NSError *error, id response)) callback;

- (void)getAllEventsWithResponse:(void(^)(NSError *error, id response)) callback;

- (void)postEventWithParams:(NSDictionary *)params withImage:(UIImage *)image
                   response:(void(^)(NSError *error, id response)) callback;

@end
