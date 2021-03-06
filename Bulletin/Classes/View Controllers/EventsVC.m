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

@property (strong, nonatomic) NSArray               *events;
@property (strong, nonatomic) MBProgressHUD         *loadingHUD;
@property (strong, nonatomic) UIImage               *chosenEventImage;
@property (strong, nonatomic) UIGestureRecognizer   *panGesture;
@property (strong, nonatomic) NSMutableDictionary   *eventImageInfo;
@property (strong, nonatomic) NSDateFormatter       *stringToDateFormatter;
@property (strong, nonatomic) NSDateFormatter       *dateToStringFormatter;

@end

@implementation EventsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( ![[NSUserDefaults standardUserDefaults] valueForKey:@"First Launch"] )
    {
        [self performSelector:@selector(presentWelcomeView) withObject:nil afterDelay:0.1];
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
    [self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
    [self.navigationController.view addGestureRecognizer:self.panGesture];
    
    if( [[APIManager sharedManager] eventsNeedUpdate] )
    {
        [self updateEvents];
        [[APIManager sharedManager] setEventsNeedUpdate:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.panGesture];
}

- (void) addEvent
{
    if( [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"] )
    {
        [self performSegueWithIdentifier:@"add_event" sender:nil];
    }
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
    BulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.eventNameLabel.text  = [[self.events objectAtIndex:indexPath.row] objectForKey:@"eventName"];
    cell.eventPlaceLabel.text = [[self.events objectAtIndex:indexPath.row] objectForKey:@"location"];
    
    NSDate *dateFromString = [self.stringToDateFormatter dateFromString:[[self.events objectAtIndex:indexPath.row] objectForKey:@"start"]];
    
    cell.eventDateLabel.text  = [self.dateToStringFormatter stringFromDate:dateFromString];
    
    NSString *imageFile = [[self.events objectAtIndex:indexPath.row] objectForKey:@"path"];
    
    NSString *imageURL  = [NSString stringWithFormat:@"%@evtImg/%@", [APIManager serverURL], imageFile];
    
    __weak BulletinCell *weakCell = cell;

    if( [imageFile isEqualToString:@"none"] )
    {
        cell.eventImageView.image = [UIImage imageNamed:@"placeholder"];
        [self.eventImageInfo setObject:@"noImage" forKey:@(indexPath.row)];
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
    
    Event *chosenEvent = [Event eventFromDictionary:self.events[indexPath.row]];
    chosenEvent.image  = chosenCell.eventImageView.image;
    
    if( [self.eventImageInfo objectForKey:@(indexPath.row)] )
    {
        chosenEvent.image = nil;
    }
    
    [[APIManager sharedManager] getEventInfoForEventID:chosenEvent.eventID response:^(NSError *error, id response)
    {
        if( !error )
        {
            NSDictionary *details = [response objectForKey:@"details"][0];
            chosenEvent.latitude  = [[details objectForKey:@"latitude"] doubleValue];
            chosenEvent.longitude = [[details objectForKey:@"longitude"] doubleValue];
            chosenEvent.description = [details objectForKey:@"description"];
            [chosenEvent addCategory:[details objectForKey:@"catagory1"]];
            [chosenEvent addCategory:[details objectForKey:@"catagory2"]];
            [self performSegueWithIdentifier:@"event_detail" sender:chosenEvent];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"event_detail"] )
    {
        Event *chosenEvent = (Event *)sender;
        
        EventDetailVC *dest = segue.destinationViewController;
        dest.event = chosenEvent;
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

- (NSMutableDictionary *)eventImageInfo
{
    if( !_eventImageInfo )
    {
        _eventImageInfo = [[NSMutableDictionary alloc] init];
    }
    
    return _eventImageInfo;
}

- (UIGestureRecognizer *)panGesture
{
    if( !_panGesture )
    {
        _panGesture = self.revealViewController.panGestureRecognizer;
    }
    
    return _panGesture;
}

- (NSDateFormatter *)stringToDateFormatter
{
    if( !_stringToDateFormatter )
    {
        _stringToDateFormatter = [[NSDateFormatter alloc] init];
        _stringToDateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        [_stringToDateFormatter setLenient:YES];
    }
    
    return _stringToDateFormatter;
}

- (NSDateFormatter *)dateToStringFormatter
{
    if( !_dateToStringFormatter )
    {
        _dateToStringFormatter = [[NSDateFormatter alloc] init];
        _dateToStringFormatter.dateFormat = @"EEE MMM d, h:mma";
    }
    
    return _dateToStringFormatter;
}

@end
