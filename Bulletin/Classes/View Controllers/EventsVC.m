//
//  InitialVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 2/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "EventsVC.h"
//#import "EventCell.h"
#import "BulletinCell.h"
#import "APIManager.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface EventsVC ()

@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) MBProgressHUD *loadingHUD;

@end

@implementation EventsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( ![[NSUserDefaults standardUserDefaults] valueForKey:@"First Launch"] )
    {
        [self performSelector:@selector(presentWelcomeView) withObject:nil afterDelay:0.1];
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"First Launch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    UINib *pickerCellNib = [UINib nibWithNibName:@"BulletinCell" bundle:nil];
    [self.tableView registerNib:pickerCellNib forCellReuseIdentifier:@"eventCell"];
    
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    [refresher addTarget:self action:@selector(updateEvents) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresher;
    
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addEvent)];
    compose.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = compose;
    
    UIImage *sidebarIconImage = [UIImage imageNamed:@"sidebar"];
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithImage:sidebarIconImage style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    sidebarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    self.revealViewController.rearViewRevealWidth = 230;
    
    [self.navigationItem.rightBarButtonItem.customView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.82 green:0.69 blue:0.45 alpha:1];
    
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
    [[APIManager sharedManager] authorizeGETrequest:@"pkEvt" additionalParamters:@{}
                                           response:^(NSError *error, id response)
     {
         [self.loadingHUD hide:YES];
         
         if( error )
         {
             NSLog(@"%@", error);
         }
         
         else
         {
             self.events = [response objectForKey:@"events"];
             [self.tableView reloadData];
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (void) addEvent
{
    [self performSegueWithIdentifier:@"add_event" sender:nil];
}

- (void)presentWelcomeView
{
    [self performSegueWithIdentifier:@"welcome" sender:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    headerView.backgroundColor = self.tableView.backgroundColor;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"eventCell";
    BulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.eventNameLabel.text  = [[self.events objectAtIndex:indexPath.row] objectForKey:@"eventName"];
    cell.eventPlaceLabel.text = [[self.events objectAtIndex:indexPath.row] objectForKey:@"location"];
    cell.eventDateLabel.text  = [[self.events objectAtIndex:indexPath.row] objectForKey:@"start"];
    
    NSString *imageFile = [[self.events objectAtIndex:indexPath.row] objectForKey:@"path"];
    NSLog(@"%@", imageFile);
    
    /*if( [imageFile isEqualToString:@"none"] )
    {
        cell.image.image = [UIImage imageNamed:@"ninjaturtle"];
    }
    
    else
    {
        NSString *imageURL  = [NSString stringWithFormat:@"%@evtImg/%@", [APIManager serverURL], imageFile];
        
        [cell.image setImageWithURL:[NSURL URLWithString:imageURL]];
    }*/
    
    UIView *selectionView = [[UIView alloc] initWithFrame:cell.cardView.frame];
    selectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    selectionView.layer.cornerRadius = 10;
    cell.selectedBackgroundView = selectionView;
    
    NSString *imageURL  = [NSString stringWithFormat:@"%@evtImg/%@", [APIManager serverURL], imageFile];

    if( [imageFile isEqualToString:@"none"] )
    {
        cell.eventImageView.image = [UIImage imageNamed:@"ninjaturtle"];
    }
    
    else
    {
        [[APIManager sharedManager] authorizeImageGETRequest:imageURL response:^(NSError *error, id response)
         {
             if( !error )
             {
                 NSLog(@"%@", response);
                 
                 cell.eventImageView.image = (UIImage *)response;
             }
         }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"event_detail" sender:nil];
}

- (void)updateEvents
{
    [[APIManager sharedManager] authorizeGETrequest:@"pkEvt" additionalParamters:@{}
                                           response:^(NSError *error, id response)
     {
         if( error != nil )
         {
             NSLog(@"%@", error);
         }
         
         else
         {
             self.events = [response objectForKey:@"events"];
             [self.tableView reloadData];
         }
         
         [self.refreshControl endRefreshing];
     }];
}

@end
