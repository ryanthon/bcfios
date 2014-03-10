//
//  MyEventsVC.m
//  Bulletin
//
//  Created by Wesley Yao on 3/10/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "SWRevealViewController.h"
#import "MyEventsVC.h"

@interface MyEventsVC ()

@property (strong, nonatomic) NSArray *events;

@end

@implementation MyEventsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UINib *myEventNib = [UINib nibWithNibName:@"EventCell" bundle:nil];
    [self.tableView registerNib:myEventNib forCellReuseIdentifier:@"MyEventCell"];
    
    UIImage *sideBarImg = [UIImage imageNamed:@"sidebar.png"];
    
    UIBarButtonItem *icon = [[UIBarButtonItem alloc] initWithImage:sideBarImg landscapeImagePhone:sideBarImg style:UIBarButtonItemStylePlain target:self.revealViewController action:nil];
    self.navigationItem.leftBarButtonItem = icon;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tempCell"];
   // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tempCell"];
    /*static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }*/
    return cell;
}

@end
