//
//  EventDetailVC.h
//  Bulletin
//
//  Created by Ryan Khalili on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailVC : UIViewController

@property (strong, nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end
