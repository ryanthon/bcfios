//
//  APIManager.h
//  Bulletin
//
//  Created by Ryan Khalili on 2/14/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (APIManager *)sharedManager;

@property (nonatomic) BOOL isLoggedIn;
@property (strong, nonatomic) NSString *token_ID;

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

@end
