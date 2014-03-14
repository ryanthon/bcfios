//
//  SideRevealVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "SWRevealViewController.h"
#import "SideRevealVC.h"

@interface SideRevealVC ()
@property (strong, nonatomic) NSArray *titleArray;
@end

@implementation SideRevealVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    self.sideTableView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    self.sideTableView.separatorColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.sideTableView.backgroundColor = [UIColor darkGrayColor];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sideTableView deselectRowAtIndexPath:[self.sideTableView indexPathForSelectedRow] animated:YES];
    
    switch( indexPath.row )
    {
        case 0: [self performSegueWithIdentifier:@"home_segue" sender:nil]; break;
        case 1: [self performSegueWithIdentifier:@"categories_segue" sender:nil]; break;
        case 2: [self performSegueWithIdentifier:@"my_events_segue" sender:nil]; break;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        UINavigationController *frontView = (UINavigationController *)self.revealViewController.frontViewController;
        
        if( [frontView.viewControllers[0] isKindOfClass:[segue.destinationViewController class]] )
        {
            [self.revealViewController revealToggle:self.revealViewController.frontViewController];
        }
        
        else
        {
            SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
            
            SWRevealViewController* rvc = self.revealViewController;
            NSAssert( rvc != nil, @"oops! must have a revealViewController" );
            
            NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
            
            rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
            {
                UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
                [rvc setFrontViewController:nc animated:YES];
            };
        }
    }
}

- (NSArray *) titleArray
{
    if( !_titleArray )
    {
        _titleArray = @[ @"Home", @"Catagories", @"My Events"];
    }
    return _titleArray;
}

@end
