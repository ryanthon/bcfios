//
//  CatagoriesVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/11/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "CatagoriesVC.h"

static NSString *catagoryID = @"CatagoryCell";

@interface CatagoriesVC ()
@property (strong, nonatomic) NSArray *catagories;
@end

@implementation CatagoriesVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.catagories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = catagoryID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = self.catagories[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = self.catagories[indexPath.row];
            break;
        case 2:
            cell.textLabel.text = self.catagories[indexPath.row];
            break;
        case 3:
            cell.textLabel.text = self.catagories[indexPath.row];
            break;
    }
    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray *) catagories
{
    if( !_catagories)
    {
        _catagories = @[@"Fundraiser", @"Free Food", @"Party", @"Tech Talk"];
    }
    return _catagories;
}
@end
