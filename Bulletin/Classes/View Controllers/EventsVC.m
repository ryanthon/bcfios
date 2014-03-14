//
//  InitialVC.m
//  Bulletin
//
//  Created by Ryan Khalili on 2/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "EventsVC.h"
#import "BulletinCell.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "Event.h"
#import "EventDetailVC.h"

@interface EventsVC ()

@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) MBProgressHUD *loadingHUD;
@property (strong, nonatomic) UIImage *chosenEventImage;

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
        
    [self.view.window addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
    
    [[APIManager sharedManager] getAllEventsWithResponse:^(NSError *error, id response)
     {
         [self.loadingHUD hide:YES];
         
         if( error != nil )
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"eventCell";
    BulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.eventNameLabel.text  = [[self.events objectAtIndex:indexPath.row] objectForKey:@"eventName"];
    cell.eventPlaceLabel.text = [[self.events objectAtIndex:indexPath.row] objectForKey:@"location"];
    cell.eventDateLabel.text  = [[self.events objectAtIndex:indexPath.row] objectForKey:@"start"];
    
    NSString *imageFile = [[self.events objectAtIndex:indexPath.row] objectForKey:@"path"];
    
    NSString *imageURL  = [NSString stringWithFormat:@"%@evtImg/%@", [APIManager serverURL], imageFile];
    
    __weak BulletinCell *weakCell = cell;

    if( [imageFile isEqualToString:@"none"] )
    {
        cell.eventImageView.image = [UIImage imageNamed:@"pin.jpg"];
    }
    
    else
    {
        [[APIManager sharedManager] authorizeImageGETRequest:imageURL response:^(NSError *error, id response)
         {
             if( !error )
             {
                 weakCell.eventImageView.image = (UIImage *)response;
                 [weakCell setNeedsLayout];
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
    BulletinCell *chosenCell = (BulletinCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.chosenEventImage = chosenCell.eventImageView.image;
    [self performSegueWithIdentifier:@"event_detail" sender:@(indexPath.row)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"event_detail"] )
    {
        NSNumber *rowNum = (NSNumber *)sender;
        NSInteger row = [rowNum integerValue];
        NSDictionary *eventDict = self.events[row];
        Event *event = [Event eventFromDictionary:eventDict];
        event.image = self.chosenEventImage;
        
        EventDetailVC *dest = segue.destinationViewController;
        dest.event = event;
    }
}

- (void)updateEvents
{
    [[APIManager sharedManager] getAllEventsWithResponse:^(NSError *error, id response)
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
