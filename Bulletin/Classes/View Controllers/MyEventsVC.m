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

@interface MyEventsVC ()

@property (strong, nonatomic) NSArray *events;

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
    
    [[APIManager sharedManager] getMyEventsWithResponse:^(NSError *error, id response )
     {
         //[self.loadingHUD hide:YES];
         
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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
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
    
    cell.eventNameLabel = self.events[indexPath.row][@"eventName"];
    cell.eventDateLabel = self.events[indexPath.row][@"start"];
    cell.eventPlaceLabel = self.events[indexPath.row][@"location"];
    
    return cell;
}

@end
