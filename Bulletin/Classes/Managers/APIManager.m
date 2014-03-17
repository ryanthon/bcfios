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

static NSString *const baseAPIURL = @"http://54.186.50.209/api/";

+ (APIManager *)sharedManager
{
    static APIManager *manager = nil;
    
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        manager = [[APIManager alloc] initWithBaseURL:[NSURL URLWithString:baseAPIURL]];
    });
    
    return manager;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if( self )
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"bcf" password:@"cse190"];
    }
    
    return self;
}

+ (NSString *)serverURL
{
    return @"http://54.186.50.209/";
}

- (void)postEventWithParams:(NSDictionary *)params withImage:(UIImage *)image
                   response:(void(^)(NSError *error, id response))callback
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    [parameters setObject:@"4" forKey:@"uid"];
    
    [self POST:@"addEvent" parameters:parameters
    success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSString *eid = [[[responseObject objectForKey:@"success"] objectAtIndex:0] objectForKey:@"success"];
        
        if( image )
        {
            [self postImage:image forEvent:eid response:callback];
        }
        else
        {
            callback( nil, responseObject );
        }
    }
    failure:^(NSURLSessionDataTask *task, NSError *error )
    {
        callback( error, nil);
    }];
}

- (void)postImage:(UIImage *)image forEvent:(NSString *)eid response:(void(^)(NSError *error, id response))callback
{
    NSDictionary *params = @{@"enctype" : @"multipart/form-data", @"eid" : eid };
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [self POST:@"addImg" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
    }
    success:^(NSURLSessionDataTask *task, id responseObject)
    {
        callback( nil, responseObject );
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        callback( error, nil );
    }];
}

- (void)getAllEventsWithResponse:(void (^)(NSError *, id response))callback
{
    [self GET:@"pkEvt" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"%@", responseObject);
        callback( nil, responseObject );
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        callback( error, nil );
    }];
}

- (void)getEventInfoForEventID:(NSString *)eventID response:(void (^)(NSError *, id response))callback
{
    NSLog(@"%@", eventID);
    [self POST:@"moarDetails" parameters:@{ @"eid" : eventID } success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"%@", responseObject);
        callback( nil, responseObject );
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        callback( error, nil );
    }];
}

- (void)getMyEventsWithResponse:(NSString *)userID response:(void (^)(NSError *error, id response))callback
{
    [self POST:@"myEvents" parameters:@{ @"uid" : @"4" } success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@", responseObject);
         callback( nil, responseObject );
     }
      failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         callback( error, nil );
     }];
}

- (void)authorizeImageGETRequest:(NSString *)urlPath response:(void (^)(NSError *error, id))callback
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

- (void)getEventsByCatagory:(NSString *)category response:(void (^)(NSError *, id))callback
{
    [self POST:@"getEventsByCat" parameters:@{ @"cat" : category }
    success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"%@", responseObject);
        callback( nil, responseObject );
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        callback( error, nil );
    }];
}

- (void)removeEventWithEventID:(NSString *)eventID response:(void (^)(NSError *, id))callback
{
    [self POST:@"removeEvent" parameters:@{ @"eid" : eventID }
    success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"%@", responseObject);
        callback( nil, responseObject );
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        callback( error, nil );
    }];
}

- (void)editEventWithParams:(NSDictionary *)params withImage:(UIImage *)image response:(void (^)(NSError *, id))callback
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    [parameters setObject:@"4" forKey:@"uid"];
    
    [self POST:@"editEvent" parameters:parameters
    success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSString *eid = [parameters objectForKey:@"eid"];
         
        if( image )
        {
            [self postImage:image forEvent:eid response:callback];
        }
        else
        {
            callback( nil, responseObject );
        }
    }
    failure:^(NSURLSessionDataTask *task, NSError *error )
    {
        callback( error, nil);
    }];
}

- (void)likeEventWithEventID:(NSString *)eventID response:(void (^)(NSError *, id))callback
{
    [self POST:@"upvote" parameters:@{ @"eid" : eventID }
    success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"%@", responseObject);
        callback( nil, responseObject );
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        callback( error, nil );
    }];
}

@end
