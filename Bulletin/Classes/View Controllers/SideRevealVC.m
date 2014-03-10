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
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.sideTableView.backgroundColor = [UIColor darkGrayColor];
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
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
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
