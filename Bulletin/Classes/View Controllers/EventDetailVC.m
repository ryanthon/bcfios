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
@property (strong, nonatomic) UIView     *locationView;
@property (strong, nonatomic) UIView     *detailsView;

@property (strong, nonatomic) UILabel    *locationLabel;
@property (strong, nonatomic) UILabel    *startDateLabel;
@property (strong, nonatomic) UILabel    *endDateLabel;
@property (strong, nonatomic) UILabel    *descriptionLabel;

@property (strong, nonatomic) UIBarButtonItem *likeButton;

@end

@implementation EventDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MMM d, hh:mma";
    [dateFormatter setLenient:YES];
    
    self.startDateLabel.text = [dateFormatter stringFromDate:self.event.startDate];
    self.endDateLabel.text   = [dateFormatter stringFromDate:self.event.endDate];
    [self adjustLabelSize:self.startDateLabel];
    [self adjustLabelSize:self.endDateLabel];
    
    self.locationLabel.text = self.event.locationDetails;
    [self adjustLabelSize:self.locationLabel];
    self.descriptionLabel.text = self.event.description;
    [self adjustLabelSize:self.descriptionLabel];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.alpha = 0;
    [self.imageView addSubview:[self titleViewWithName:self.event.name]];
    
    UIImage *likeImage = [UIImage imageNamed:@"like"];
    self.likeButton = [[UIBarButtonItem alloc] initWithImage:likeImage style:UIBarButtonItemStylePlain target:self action:@selector(likeEvent)];
    self.likeButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.likeButton;
    
    if( self.event.image )
    {
        self.imageView.image = self.event.image;
    }
    
    else
    {
        self.imageView.image = [UIImage imageNamed:@"noimage"];
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
    [containerView addSubview:self.imageView];
    [containerView addSubview:self.detailsView];
    [containerView addSubview:self.locationView];
    
    [self.scrollView addSubview:containerView];
    
    int height = self.detailsView.frame.origin.y + self.detailsView.frame.size.height + 10;
    self.scrollView.contentSize = CGSizeMake(320, height);
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

- (void)adjustLabelSize:(UILabel *)label
{
    CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
    
    CGRect newFrame = [label.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17.0f] } context:nil];
    
    CGPoint oldOrigin = label.frame.origin;
    newFrame.origin = oldOrigin;
    newFrame.size.width = 280;
    
    label.frame = newFrame;
}

- (void)likeEvent
{
    
}

- (UIView *)titleViewWithName:(NSString *)name
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 320, 40)];
    titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.40];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 40)];
    titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:24.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = name;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleView addSubview:titleLabel];
    
    return titleView;
}

- (UIView *)detailsView
{
    if( !_detailsView )
    {
        int y = 220 + self.locationView.frame.size.height;
        _detailsView = [[UIView alloc] initWithFrame:CGRectMake(10, y, 300, 500)];
        _detailsView.backgroundColor = [UIColor whiteColor];
        _detailsView.layer.borderWidth = 1;
        _detailsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UILabel *startDateHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        startDateHeader.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        startDateHeader.text = @" Start Time";
        startDateHeader.textColor = [UIColor whiteColor];
        startDateHeader.font = [UIFont systemFontOfSize:15.0f];
        [_detailsView addSubview:startDateHeader];
        
        [_detailsView addSubview:self.startDateLabel];
        
        int endHeaderY = 35 + self.startDateLabel.frame.size.height;
        UILabel *endDateHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, endHeaderY, 300, 20)];
        endDateHeader.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        endDateHeader.text = @" End Time";
        endDateHeader.textColor = [UIColor whiteColor];
        endDateHeader.font = [UIFont systemFontOfSize:15.0f];
        [_detailsView addSubview:endDateHeader];
        
        [_detailsView addSubview:self.endDateLabel];
        
        int infoHeaderY = 70 + self.startDateLabel.frame.size.height + self.endDateLabel.frame.size.height;
        UILabel *infoHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, infoHeaderY, 300, 20)];
        infoHeader.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        infoHeader.text = @" Event Information";
        infoHeader.textColor = [UIColor whiteColor];
        infoHeader.font = [UIFont systemFontOfSize:15.0f];
        [_detailsView addSubview:infoHeader];
        
        [_detailsView addSubview:self.descriptionLabel];
        
        CGRect newRect = _detailsView.frame;
        int newHeight = 110 + self.descriptionLabel.frame.size.height + self.endDateLabel.frame.size.height +
                        self.startDateLabel.frame.size.height;
        CGSize newSize = CGSizeMake(300, newHeight);
        newRect.size = newSize;
        _detailsView.frame = newRect;
    }
    
    return _detailsView;
}

- (UIView *)locationView
{
    if( !_locationView )
    {
        int height = 160 + self.locationLabel.frame.size.height;
        _locationView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, 300, height)];
        _locationView.backgroundColor = [UIColor whiteColor];
        _locationView.layer.borderWidth  = 1;
        _locationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_locationView addSubview:self.mapView];
        [_locationView addSubview:self.locationLabel];
    }
    
    return _locationView;
}

- (UILabel *)locationLabel
{
    if( !_locationLabel )
    {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 280, 30)];
        _locationLabel.numberOfLines = 2;
        _locationLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _locationLabel;
}

- (UILabel *)startDateLabel
{
    if( !_startDateLabel )
    {
        _startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 280, 20)];
    }
    
    return _startDateLabel;
}

- (UILabel *)endDateLabel
{
    if( !_endDateLabel )
    {
        int y = 60 + self.startDateLabel.frame.size.height;
        _endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 280, 20)];
    }
    
    return _endDateLabel;
}

- (UILabel *)descriptionLabel
{
    if( !_descriptionLabel )
    {
        int y = 95 + self.startDateLabel.frame.size.height + self.endDateLabel.frame.size.height;
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 280, 20)];
        _descriptionLabel.numberOfLines = 0;
    }
    
    return _descriptionLabel;
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