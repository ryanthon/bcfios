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
    
    [self.view addSubview:self.descriptionField];
    self.descriptionField.text = self.event.description;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.descriptionField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.descriptionField resignFirstResponder];
}

- (IBAction)submitDescription:(UIBarButtonItem *)sender
{
    self.event.description = self.descriptionField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextView *)descriptionField
{
    if( !_descriptionField )
    {
        _descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, 300, 250)];
        _descriptionField.layer.borderWidth = 1.0f;
        _descriptionField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _descriptionField.layer.cornerRadius = 8;
        _descriptionField.font = [UIFont systemFontOfSize:17.0f];
        _descriptionField.delegate = self;
    }
    
    return _descriptionField;
}

@end
