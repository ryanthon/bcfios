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
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    return cell;
}

@end
