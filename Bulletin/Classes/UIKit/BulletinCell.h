//
//  BulletinCell.h
//  Bulletin
//
//  Created by Ryan Khalili on 3/10/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BulletinCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel        *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel        *eventPlaceLabel;

@end
