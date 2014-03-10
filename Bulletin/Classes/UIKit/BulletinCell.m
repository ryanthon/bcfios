//
//  BulletinCell.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/10/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "BulletinCell.h"

@implementation BulletinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    self.cardView.layer.cornerRadius = 10;
    [self.cardView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [self.cardView.layer setShadowOpacity:0.8];
    [self.cardView.layer setShadowRadius:2.0];
    [self.cardView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    self.eventImageView.layer.cornerRadius = 10;
    self.eventImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
