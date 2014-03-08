//
//  AddEventVCViewController.m
//  Bulletin
//
//  Created by Wesley Yao on 3/7/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "AddEventVC.h"
#import "TextCell.h"

static NSString *kTextCellID = @"textCell";
static NSString *kTimeCellID = @"timeCell";
static NSString *kSegueCell  = @"Cell";

@interface AddEventVC ()

@property (strong, nonatomic) NSArray *titleArray;

@end

@implementation AddEventVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIColor *blueColor = [UIColor colorWithRed:0.45 green:0.67 blue:0.85 alpha:1];
    self.navigationController.navigationBar.barTintColor = blueColor;
}

- (IBAction)cancelButtonTap:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *) titleArray
{
    if( !_titleArray )
    {
        _titleArray = @[@"Name", @"Start Time", @"End Time", @"Description", @"Location"];
    }
    return _titleArray;
}
@end
