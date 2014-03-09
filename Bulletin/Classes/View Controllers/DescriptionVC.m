//
//  DescriptionVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "DescriptionVC.h"

@interface DescriptionVC ()

@end

@implementation DescriptionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITextView *descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, 300, 250)];
    descriptionField.layer.borderWidth = 1.0f;
    descriptionField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    descriptionField.layer.cornerRadius = 8;
    descriptionField.font = [UIFont systemFontOfSize:17.0f];
    [self.view addSubview:descriptionField];
    descriptionField.delegate = self;
    self.descriptionField = descriptionField;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.descriptionField becomeFirstResponder];
}

- (IBAction)submitDescription:(UIBarButtonItem *)sender
{
    self.event.description = self.descriptionField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
