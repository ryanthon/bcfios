//
//  CategoryChooserVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "CategoryChooserVC.h"

@interface CategoryChooserVC ()

@property (strong, nonatomic) NSArray *categories;

@end

@implementation CategoryChooserVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.categories[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if( [[self.event getCategories] containsObject:self.categories[indexPath.row]] )
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSArray *)categories
{
    if( !_categories )
    {
        _categories = @[ @"Fundraiser", @"Party", @"Free Food", @"Tech Talk" ];
    }
    
    return _categories;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark )
    {
        [self.event removeCategory:self.categories[indexPath.row]];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        if( [[self.event getCategories] count] < 2 )
        {
            [self.event addCategory:self.categories[indexPath.row]];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}


@end
