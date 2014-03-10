//
//  InitialVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 2/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "EventsVC.h"
#import "EventCell.h"
#import "APIManager.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

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
    
    UINib *pickerCellNib = [UINib nibWithNibName:@"EventCell" bundle:nil];
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
    
    [self.navigationItem.rightBarButtonItem.customView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"eventCell";
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.eventName.text  = [[self.events objectAtIndex:indexPath.row] objectForKey:@"eventName"];
    cell.placeLabel.text = [[self.events objectAtIndex:indexPath.row] objectForKey:@"location"];
    cell.timeLabel.text  = [[self.events objectAtIndex:indexPath.row] objectForKey:@"start"];
    
    NSString *imageFile = [[self.events objectAtIndex:indexPath.row] objectForKey:@"path"];
    NSString *imageURL  = [NSString stringWithFormat:@"%@evtImg/%@", [APIManager serverURL], imageFile];
    
    [[APIManager sharedManager] authorizeImageGETRequest:imageURL response:^(NSError *error, id response)
     {
         if( !error )
         {
             NSLog(@"%@", response);
             cell.image.image = (UIImage *)response;
         }
     }];
    
    //[cell.image setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ninjaturtle"]];
    
    //cell.image.image = [UIImage imageNamed:@"ninjaturtle"];
    
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
