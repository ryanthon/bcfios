//
//  APIManager.m
//  Bulletin
//
//  Created by Ryan Khalili on 2/14/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"

@implementation APIManager

static APIManager *manager = nil;

static NSString *const baseAPIURL = @"http://54.186.50.209/api/";

+ (APIManager *)sharedManager
{
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        manager = [[APIManager alloc] init];
    });
    
    return manager;
}

+ (NSString *)serverURL
{
    return @"http://54.186.50.209/";
}

- (void)sendPushToken: (NSString*) pushToken
            userToken: (NSString*) userToken
             response:(void(^)(BOOL success, NSError *error)) callback
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseAPIURL]];
    NSDictionary *loginParams = @{@"token_ID":userToken, @"push_token": pushToken};
    
    [manager POST:@"push/save_push_token.php" parameters:loginParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully sent push notification token!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in push notification: %@", [error localizedDescription]);
    }];
}

- (void)authorizeGETrequest:(NSString *)urlPath
        additionalParamters:(NSDictionary *)params
                   response:(void(^)(NSError *error, id response)) callback
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseAPIURL]];
    
    NSURLCredential *credentials = [NSURLCredential credentialWithUser:@"bcf" password:@"cse190" persistence:NSURLCredentialPersistenceNone];
    [manager setCredential:credentials];
        
    [manager GET:urlPath parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        callback(error, nil);
    }];
}

- (void)authorizeImageGETRequest:(NSString *)urlPath response:(void (^)(NSError *, id))callback
{
    NSURLRequest *url = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:url];
    
    NSURLCredential *credentials = [NSURLCredential credentialWithUser:@"bcf" password:@"cse190" persistence:NSURLCredentialPersistenceNone];
    [requestOperation setCredential:credentials];
    
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        callback(error, nil);
    }];
    [requestOperation start];
}

- (void)authorizePOSTrequest:(NSString *)urlPath
                    forImage:(UIImage *)image
                    response:(void(^)(NSError *error, id response)) callback

{
    /*AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseAPIURL]];
    
    NSURLCredential *credentials = [NSURLCredential credentialWithUser:@"bcf" password:@"cse190" persistence:NSURLCredentialPersistenceNone];
    [manager setCredential:credentials];
    
    NSDictionary *params = @{@"enctype" : @"multipart/form-data"};
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [manager POST:urlPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"name" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        callback(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        callback(error, nil);
    }];*/
    
    NSString *url = [NSString stringWithFormat:@"%@%@", baseAPIURL, urlPath];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSDictionary *params = @{@"enctype" : @"multipart/form-data", @"eid" : @"7" };
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"bcf" password:@"cse190"];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"screenshot operation success!  %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Operation Error: %@", error);
    }];
}


- (void)authorizePOSTrequest:(NSString *)urlPath
         additionalParamters:(NSDictionary *)params
                    response:(void(^)(NSError *error, id response)) callback
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseAPIURL]];
    
    [manager POST:urlPath parameters:[self addAuthTokenToParamters:params] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Success: %@", responseObject);
        callback(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        callback(error, nil);
    }];
}

- (NSDictionary *)addAuthTokenToParamters:(NSDictionary *)params
{
    if (self.token_ID == nil) return params;
    
    NSMutableDictionary *combinedDict = [[NSMutableDictionary alloc] initWithDictionary:params];
    [combinedDict addEntriesFromDictionary:@{@"token_ID": self.token_ID}]; // Add token credentials to parameters
    return combinedDict;
}


@end
