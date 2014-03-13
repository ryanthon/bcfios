//
//  DatePickerCell.m
//  Bulletin
//
//  Created by Ryan Khalili on 3/8/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "DatePickerCell.h"

@implementation DatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self )
    {
        [self setupDatePicker];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if( self )
    {
        [self setupDatePicker];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupDatePicker
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, -25, 320, 162)];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minuteInterval = 5;
    
    NSDate *currentDate = [NSDate date];
    self.datePicker.date = currentDate;
    self.datePicker.minimumDate = currentDate;
    
    [self.contentView addSubview:self.datePicker];
}

@end
