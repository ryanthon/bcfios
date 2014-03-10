//
//  LocationVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "LocationVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface LocationVC () <UITextViewDelegate, GMSMapViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UITextView *detailsField;
@property (nonatomic) BOOL keyboardIsShown;

@end

@implementation LocationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:32.8812
                                                            longitude:-117.2375
                                                                 zoom:15];
    
    CGRect mapRect = CGRectMake(0, 65, 320, 200);
    self.mapView = [GMSMapView mapWithFrame:mapRect camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.detailsField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.detailsField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.detailsField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.detailsField resignFirstResponder];
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
}

- (UITextView *)detailsField
{
    if( !_detailsField )
    {
        _detailsField = [[UITextView alloc] initWithFrame:CGRectMake(10, 270, 300, 75)];
        _detailsField.layer.borderWidth = 1.0f;
        _detailsField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _detailsField.layer.cornerRadius = 8;
        _detailsField.font = [UIFont systemFontOfSize:17.0f];
        _detailsField.delegate = self;
    }
    
    return _detailsField;
}

@end
