//
//  EventDetailVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "EventDetailVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface EventDetailVC () <GMSMapViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) UIView     *detailView;

@end

@implementation EventDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;

    [self.scrollView addSubview:self.detailView];
    
    self.imageView.alpha = 0;
    
    [self.imageView addSubview:[self titleViewWithName:self.event.name]];
    
    self.imageView.image = self.event.image;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 3 );
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.5 delay:0.2 options: UIViewAnimationOptionCurveEaseIn
    animations:^
    {
        self.imageView.alpha = 1;
    }
    completion:nil];
}

- (UIView *)titleViewWithName:(NSString *)name
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 320, 40)];
    titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 40)];
    titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:24.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = name;
    [titleView addSubview:titleLabel];
    
    return titleView;
}

- (UIView *)detailView
{
    if( !_detailView )
    {
        _detailView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, 300, 500)];
        _detailView.layer.cornerRadius = 10;
        [_detailView addSubview:self.mapView];
    }
    
    return _detailView;
}

- (GMSMapView *)mapView
{
    if( !_mapView )
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.event.latitude
                                                                longitude:self.event.longitude
                                                                     zoom:15];
        
        CGRect mapRect = CGRectMake(0, 0, 300, 140);
        _mapView = [GMSMapView mapWithFrame:mapRect camera:camera];
        _mapView.myLocationEnabled = YES;
        _mapView.delegate = self;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.event.latitude, self.event.longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = _mapView;
    }
    
    return _mapView;
}

@end