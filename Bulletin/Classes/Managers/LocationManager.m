//
//  LocationManager.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/5/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *clManager;
@property (strong, nonatomic) CLLocation        *currentLocation;

@end

@implementation LocationManager

static LocationManager *manager = nil;

+ (LocationManager *)sharedManager
{
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        manager = [[LocationManager alloc] init];
    });
    
    return manager;
}

- (void)startLocationUpdates
{
    [self.clManager startUpdatingLocation];
}

- (void)stopLocationUpdates
{
    [self.clManager stopUpdatingLocation];
}

- (CLLocation *)getCurrentLocation
{
    return self.currentLocation;
}

- (CLLocationManager *)clManager
{
    if( !_clManager )
    {
        _clManager = [[CLLocationManager alloc] init];
        _clManager.delegate = self;
    }
    
    return _clManager;
}

@end
