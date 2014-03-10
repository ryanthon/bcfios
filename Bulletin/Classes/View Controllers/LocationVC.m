//
//  LocationVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "LocationVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface LocationVC ()

@property (strong, nonatomic) GMSMapView *mapView;

@end

@implementation LocationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:32.8812
                                                            longitude:-117.2375
                                                                 zoom:15];
    
    CGRect mapRect = CGRectMake(0, 65, 320, 300);
    self.mapView = [GMSMapView mapWithFrame:mapRect camera:camera];
    self.mapView.myLocationEnabled = YES;
        
    
    [self.view addSubview:self.mapView];
}

@end
