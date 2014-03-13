//
//  EventDetailVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "EventDetailVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface EventDetailVC ()

//@property (strong, nonatomic) UIView *titleView;

@end

@implementation EventDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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

@end