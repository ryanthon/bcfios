//
//  SideRevealVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "SideRevealVC.h"

static NSString *sideSegueCellID = @"Cell";

@interface SideRevealVC ()
@property (strong, nonatomic) NSArray *titleArray;
@end

@implementation SideRevealVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    self.sideTableView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    self.sideTableView.separatorColor = [UIColor colorWithRed:0.2 green:0.23 blue:0.26 alpha:1];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = nil;
    
    switch (indexPath.row) {
        case 0:
            cellID = sideSegueCellID;
            break;
        case 1:
            cellID = sideSegueCellID;
            break;
        case 2:
            cellID = sideSegueCellID;
            break;
        case 3:
            cellID = sideSegueCellID;
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray *) titleArray
{
    if( !_titleArray )
    {
        _titleArray = @[ @"Home", @"My Events", @"Settings", @"Logout" ];
    }
    return _titleArray;
}

@end
