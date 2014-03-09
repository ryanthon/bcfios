//
//  TextCell.h
//  Bulletin
//
//  Created by Wesley Yao on 3/7/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFieldCellDelegate <NSObject>

@required
- (void)textField:(UITextField *)textField didEndEditingInCell:(UITableViewCell *)cell;
- (void)textField:(UITextField *)textField didBeginEditingInCell:(UITableViewCell *)cell;
- (BOOL)textFieldShouldReturn:(UITextField *)textField InCell:(UITableViewCell *)cell;

@end

@interface TextFieldCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<TextFieldCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
