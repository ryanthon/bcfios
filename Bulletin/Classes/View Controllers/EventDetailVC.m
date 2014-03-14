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
@property (strong, nonatomic) UILabel    *detailsLabel;

@end

@implementation EventDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.alpha = 0;
    [self.imageView addSubview:[self titleViewWithName:self.event.name]];
    self.imageView.image = self.event.image;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
    [containerView addSubview:self.imageView];
    [containerView addSubview:self.detailView];
    
    [self.scrollView addSubview:containerView];
    
    self.scrollView.contentSize = CGSizeMake(320, 800);
    
    NSDateFormatter *startFormatter = [[NSDateFormatter alloc] init];
    startFormatter.dateFormat = @"EEE MMM d, hh:mm";
    
    //NSDateFormatter *endFormatter = [[NSDateFormatter alloc] init];
    //endFormatter.dateFormat   = @"EEE MMM d, hh:mm";

    NSString *startDateString = [startFormatter stringFromDate:self.event.startDate];
    //NSString *endDateString   = [endFormatter stringFromDate:self.event.endDate];
    self.detailsLabel.text = [NSString stringWithFormat:@"%@\n\n\n%@\n\n\n%@", startDateString,
                                  self.event.locationDetails, self.event.description];
    [self.detailsLabel sizeToFit];
    //[self.descriptionLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseIn
    animations:^
    {
        self.imageView.alpha = 1;
    }
    completion:nil];
}

- (UIView *)titleViewWithName:(NSString *)name
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 320, 40)];
    titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.40];
    
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
        _detailView.backgroundColor = [UIColor whiteColor];
        _detailView.layer.borderWidth  = 1;
        _detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_detailView addSubview:self.mapView];
        [_detailView addSubview:self.detailsLabel];
    }
    
    return _detailView;
}

- (UILabel *)detailsLabel
{
    if( !_detailsLabel )
    {
        _detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 280, 40)];
        _detailsLabel.numberOfLines = 0;
    }
    
    return _detailsLabel;
}

- (GMSMapView *)mapView
{
    if( !_mapView )
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.event.latitude
                                                                longitude:self.event.longitude
                                                                     zoom:17];
        
        CGRect mapRect = CGRectMake(0, 0, 300, 140);
        _mapView = [GMSMapView mapWithFrame:mapRect camera:camera];
        _mapView.myLocationEnabled = YES;
        _mapView.layer.masksToBounds = YES;
        _mapView.delegate = self;
        _mapView.layer.borderWidth = 1;
        _mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _mapView.settings.scrollGestures = NO;
        _mapView.settings.zoomGestures = NO;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.event.latitude, self.event.longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = _mapView;
    }
    
    return _mapView;
}

- (UIImageView *)imageView
{
    if( !_imageView )
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 190)];
    }
    
    return _imageView;
}

@end