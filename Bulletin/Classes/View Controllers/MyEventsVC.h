//
//  MyEventsVC.h
//  Bulletin
//
//  Created by Wesley Yao on 3/10/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyEventsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
