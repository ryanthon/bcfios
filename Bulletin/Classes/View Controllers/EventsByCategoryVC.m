//
//  EventsByCatagoryVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/11/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "EventsByCategoryVC.h"
#import "BulletinCell.h"

@interface EventsByCategoryVC ()
@property (strong, nonatomic) NSArray *events;

@end

@implementation EventsByCategoryVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.category;
    UINib *myEventNib = [UINib nibWithNibName:@"BulletinCell" bundle:nil];
    [self.tableView registerNib:myEventNib forCellReuseIdentifier:@"eventCell"];
    
    
    [[APIManager sharedManager] getEventsByCatagory:self.category response:^(NSError *error, id response )
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    cell.eventNameLabel.text = self.events[indexPath.row][@"eventName"];
    cell.eventDateLabel.text = self.events[indexPath.row][@"start"];
    cell.eventPlaceLabel.text = self.events[indexPath.row][@"location"];
    
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

@end
