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
@property (strong, nonatomic) UIView *instructionsView;
@property (strong, nonatomic) GMSMarker  *currentMarker;

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
    
    if( self.event.longitude != 0 || self.event.latitude != 0 )
    {
        CLLocationCoordinate2D currentLocation = CLLocationCoordinate2DMake(self.event.latitude, self.event.longitude);
        self.currentMarker = [GMSMarker markerWithPosition:currentLocation];
        self.currentMarker.appearAnimation = kGMSMarkerAnimationPop;
        self.currentMarker.map = self.mapView;
    }
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.detailsField];
    self.detailsField.text = self.event.locationDetails;
    
    [self.view addSubview:self.instructionsView];
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
    [self.instructionsView removeFromSuperview];
    
    self.currentMarker.map = nil;
    
    GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
    self.currentMarker = marker;
    
    self.event.longitude = coordinate.longitude;
    self.event.latitude  = coordinate.latitude;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    [self.instructionsView removeFromSuperview];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.instructionsView removeFromSuperview];
}

- (IBAction)submit:(UIBarButtonItem *)sender
{
    self.event.locationDetails = self.detailsField.text;
    [self.navigationController popViewControllerAnimated:YES];
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

- (UIView *)instructionsView
{
    if( !_instructionsView )
    {
        _instructionsView = [[UIView alloc] initWithFrame:CGRectMake(5, 70, 200, 40)];
        _instructionsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _instructionsView.layer.cornerRadius = 10;
        
        UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        instructionsLabel.numberOfLines = 2;
        instructionsLabel.textColor = [UIColor whiteColor];
        instructionsLabel.text = @"Tap and hold a spot on the\n map to select a location.";
        instructionsLabel.textAlignment = NSTextAlignmentCenter;
        instructionsLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [_instructionsView addSubview:instructionsLabel];
    }
    
    return _instructionsView;
}

@end
