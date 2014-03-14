//
//  CatagoriesVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/11/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "CategoriesVC.h"
#import "SWRevealViewController.h"
#import "EventsByCategoryVC.h"

static NSString *categoryID = @"CategoryCell";

@interface CategoriesVC ()

@property (strong, nonatomic) NSArray  *categories;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation CategoriesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *sidebarIconImage = [UIImage imageNamed:@"sidebar"];
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithImage:sidebarIconImage style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    sidebarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = sidebarButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
    [self.navigationController.view addGestureRecognizer:self.panGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.panGesture];
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
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = categoryID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = self.categories[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = self.categories[indexPath.row];
            break;
        case 2:
            cell.textLabel.text = self.categories[indexPath.row];
            break;
        case 3:
            cell.textLabel.text = self.categories[indexPath.row];
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self.categoryName = @"Fundraiser";
            break;
        case 1:
            self.categoryName = @"Free Food";
            break;
        case 2:
            self.categoryName = @"Party";
            break;
        case 3:
            self.categoryName = @"Tech Talk";
            break;
    }
    
    [self performSegueWithIdentifier:@"EventsByCategory" sender:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EventsByCategoryVC *controller = (EventsByCategoryVC *)segue.destinationViewController;
    controller.category = self.categoryName;
}

- (NSArray *)categories
{
    if( !_categories)
    {
        _categories = @[@"Fundraiser", @"Free Food", @"Party", @"Tech Talk"];
    }
    
    return _categories;
}

- (UIGestureRecognizer *)panGesture
{
    if( !_panGesture )
    {
        _panGesture = self.revealViewController.panGestureRecognizer;
    }
    
    return _panGesture;
}

@end
