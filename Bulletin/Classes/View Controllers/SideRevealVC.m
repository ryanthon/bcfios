//
//  SideRevealVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "SWRevealViewController.h"
#import "SideRevealVC.h"

static NSString *sideSegueHomeID = @"CellHome";
static NSString *sideSegueEventID = @"CellEvents";
static NSString *sideSegueSettingID = @"CellSetting";
static NSString *sideSegueLogoutID = @"CellLogout";

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
            cellID = sideSegueHomeID;
            break;
        case 1:
            cellID = sideSegueEventID;
            break;
        case 2:
            cellID = sideSegueSettingID;
            break;
        case 3:
            cellID = sideSegueLogoutID;
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
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

- (NSArray *) titleArray
{
    if( !_titleArray )
    {
        _titleArray = @[ @"Home", @"My Events", @"Settings", @"Logout" ];
    }
    return _titleArray;
}

@end
