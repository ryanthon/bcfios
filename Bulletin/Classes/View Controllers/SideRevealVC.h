//
//  SideRevealVC.h
//  Bulletin
//
//  Created by Wesley Yao on 3/9/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideRevealVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sideTableView;

@end
