//
//  TextCell.m
//  Bulletin
//
//  Created by Wesley Yao on 3/7/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if( [self.delegate respondsToSelector:@selector(textField:didEndEditingInCell:)] )
    {
        [self.delegate textField:textField didEndEditingInCell:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( [self.delegate respondsToSelector:@selector(textField:didBeginEditingInCell:)] )
    {
        [self.delegate textField:textField didBeginEditingInCell:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = NO;
    
    if( [self.delegate respondsToSelector:@selector(textFieldShouldReturn:InCell:)] )
    {
        shouldReturn = [self.delegate textFieldShouldReturn:textField InCell:self];
    }
    
    return shouldReturn;
}

@end
