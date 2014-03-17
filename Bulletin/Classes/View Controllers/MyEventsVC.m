//
//  MyEventsVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/10/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "SWRevealViewController.h"
#import "MyEventsVC.h"
#import "BulletinCell.h"
#import "MBProgressHUD.h"
#import "Event.h"
#import "AddEventVC.h"

@interface MyEventsVC () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray                   *events;
@property (strong, nonatomic) NSArray                   *pics;
@property (strong, nonatomic) UIPanGestureRecognizer    *panGesture;
@property (strong, nonatomic) MBProgressHUD             *loadingHUD;
@property (strong, nonatomic) NSMutableDictionary       *eventImageInfo;
@property (strong, nonatomic) NSDateFormatter           *stringToDateFormatter;
@property (strong, nonatomic) NSDateFormatter           *dateToStringFormatter;

@end

@implementation MyEventsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UINib *myEventNib = [UINib nibWithNibName:@"BulletinCell" bundle:nil];
    [self.tableView registerNib:myEventNib forCellReuseIdentifier:@"eventCell"];
    
    self.navigationItem.title = @"My Events";
    
    UIImage *sidebarIconImage = [UIImage imageNamed:@"sidebar"];
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithImage:sidebarIconImage style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    sidebarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
    
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addEvent)];
    compose.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = compose;
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    
    if( uid )
    {
        [[APIManager sharedManager] getMyEventsWithResponse:uid response:^(NSError *error, id response )
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
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
    [self.navigationController.view addGestureRecognizer:self.panGesture];
    
    if( [[APIManager sharedManager] eventsNeedUpdate] )
    {
        [self reloadEvents];
        [[APIManager sharedManager] setEventsNeedUpdate:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.panGesture];
    self.panGesture.delegate = nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( self.events )
    {
        return self.events.count;
    }
    
    else
    {
        return 0;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    cell.eventNameLabel.text = self.events[indexPath.row][@"eventName"];
    cell.eventPlaceLabel.text = self.events[indexPath.row][@"location"];
    
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
             [self performSegueWithIdentifier:@"edit_my_event" sender:chosenEvent];
         }
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *destNavController = (UINavigationController *)segue.destinationViewController;
    AddEventVC *dest = destNavController.viewControllers[0];
    
    if( [segue.identifier isEqualToString:@"edit_my_event"] )
    {
        dest.event = (Event *)sender;
        dest.editMode = YES;
    }
    
    else if( [segue.identifier isEqualToString:@"add_my_event"] )
    {
        dest.editMode = NO;
    }
}

- (void)addEvent
{
    if( [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"] )
    {
        [self performSegueWithIdentifier:@"add_my_event" sender:nil];
    }
}

- (UIGestureRecognizer *)panGesture
{
    if( !_panGesture )
    {
        _panGesture = self.revealViewController.panGestureRecognizer;
        _panGesture.delegate = self;
    }
    
    return _panGesture;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
        
        [[APIManager sharedManager] removeEventWithEventID:self.events[indexPath.row][@"eid"] response:^(NSError *error, id response)
        {
            if( error )
            {
                
            }
            
            else
            {
                [self reloadEvents];
                NSLog(@"%@", response);
            }
        }];
    }
}

- (NSMutableDictionary *)eventImageInfo
{
    if( !_eventImageInfo )
    {
        _eventImageInfo = [[NSMutableDictionary alloc] init];
    }
    
    return _eventImageInfo;
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

- (void)reloadEvents
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    if( uid )
    {
        [[APIManager sharedManager] getMyEventsWithResponse:uid response:^(NSError *error, id response )
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
}

@end
