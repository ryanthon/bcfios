//
//  LocationManager.h
//  Bulletin
//
//  Created by Ryan Khalili on 3/5/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (LocationManager *)sharedManager;

- (void)startLocationUpdates;
- (void)stopLocationUpdates;

- (CLLocation *)getCurrentLocation;

@end
