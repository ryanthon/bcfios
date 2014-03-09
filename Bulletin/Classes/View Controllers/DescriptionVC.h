//
//  DescriptionVC.h
//  Bulletin
//
//  Created by Ryan Khalili on 3/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface DescriptionVC : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) UITextView *descriptionField;
@property (strong, nonatomic) Event *event;

@end
