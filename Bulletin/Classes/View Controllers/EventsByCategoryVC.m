//
//  EventsByCatagoryVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/11/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "EventsByCategoryVC.h"
#import "BulletinCell.h"
#import "MBProgressHUD.h"
#import "Event.h"
#import "EventDetailVC.h"

@interface EventsByCategoryVC ()

@property (strong, nonatomic) NSArray               *events;
@property (strong, nonatomic) MBProgressHUD         *loadingHUD;
@property (strong, nonatomic) NSDateFormatter       *stringToDateFormatter;
@property (strong, nonatomic) NSDateFormatter       *dateToStringFormatter;
@property (strong, nonatomic) NSMutableDictionary   *eventImageInfo;

@end

@implementation EventsByCategoryVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.category;
    UINib *myEventNib = [UINib nibWithNibName:@"BulletinCell" bundle:nil];
    [self.tableView registerNib:myEventNib forCellReuseIdentifier:@"eventCell"];
    
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
    
    [[APIManager sharedManager] getEventsByCatagory:self.category response:^(NSError *error, id response )
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
             [self performSegueWithIdentifier:@"category_event_detail" sender:chosenEvent];
         }
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"category_event_detail"] )
    {
        Event *chosenEvent = (Event *)sender;
        
        EventDetailVC *dest = segue.destinationViewController;
        dest.event = chosenEvent;
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

@end
