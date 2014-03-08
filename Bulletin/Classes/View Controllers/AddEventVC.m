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
    
    UINib *textCellNib = [UINib nibWithNibName:@"TextCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:kTextCellID];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = nil;
    
    switch( indexPath.row )
    {
        case 0: cellID = kTextCellID; break;
        case 1: cellID = kTimeCellID; break;
        case 2: cellID = kTimeCellID; break;
        case 3: cellID = kSegueCell;  break;
        case 4: cellID = kSegueCell;  break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
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
