//
//  AddEventVCViewController.m
//  Bulletin
//
//  Created by Wesley Yao on 3/7/14.
//  Copyright (c) 2014 Burlington Code Factory. All rights reserved.
//

#import "AddEventVC.h"
#import "TextFieldCell.h"
#import "DescriptionVC.h"
#import "CategoryChooserVC.h"

static NSString *kTextCellID = @"textCell";
static NSString *kTimeCellID = @"timeCell";
static NSString *kSegueCell  = @"Cell";

@interface AddEventVC () <TextFieldCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) UITextField *currentEditingField;
@property (strong, nonatomic) UIImageView *eventImage;
@property (strong, nonatomic) UILabel *chooseLabel;

@end

@implementation AddEventVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *textCellNib = [UINib nibWithNibName:@"TextFieldCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:kTextCellID];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currentEditingField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = nil;
    UITableViewCell *cell = nil;
    
    switch( indexPath.row )
    {
        case 0:
        {
            cellID = kTextCellID;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            TextFieldCell *textCell = (TextFieldCell *)cell;
            textCell.textField.placeholder = @"Enter Event Name";
            textCell.delegate = self;
        }
        break;
        
        case 1:
        {
            cellID = kSegueCell;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        break;
            
        case 2:
        {
            cellID = kTimeCellID;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        break;
        
        case 3:
        {
            cellID = kTimeCellID;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        break;
        
        case 4:
        {
            cellID = kSegueCell;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        break;
        
            
        case 5:
        {
            cellID = kSegueCell;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        break;
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:2.0];
    [view.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    UIButton *chooseImageButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 10, 80, 80)];
    chooseImageButton.backgroundColor = [UIColor whiteColor];
    [chooseImageButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *eventImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.eventImage = eventImage;
    [chooseImageButton addSubview:eventImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    label.numberOfLines = 0;
    label.text = @"Choose\nan\nImage";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [chooseImageButton addSubview:label];
    self.chooseLabel = label;
    
    [view addSubview:chooseImageButton];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch( indexPath.row )
    {
        case 1:
        {
            [self performSegueWithIdentifier:@"categories" sender:nil];
        }
        break;
            
        case 4:
        {
            [self performSegueWithIdentifier:@"description" sender:nil];
        }
        break;
            
        case 5:
        {
            
        }
        break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"description"] )
    {
        DescriptionVC *dest = segue.destinationViewController;
        dest.event = self.event;
    }
    
    if( [segue.identifier isEqualToString:@"categories"] )
    {
        CategoryChooserVC *dest = segue.destinationViewController;
        dest.event = self.event;
    }
}

- (void)chooseImage
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.eventImage.image = chosenImage;
    [self.chooseLabel removeFromSuperview];
    
    [[APIManager sharedManager] authorizePOSTrequest:@"addImg" forImage:chosenImage response:^(NSError *error, id response)
     {
         if( error )
         {
             NSLog(@"%@", [error localizedDescription]);
         }
         
         else
         {
             NSLog(@"success!");
         }
     }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)textField:(UITextField *)textField didBeginEditingInCell:(UITableViewCell *)cell
{
    self.currentEditingField = textField;
}

- (void)textField:(UITextField *)textField didEndEditingInCell:(UITableViewCell *)cell
{
    self.event.name = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField InCell:(UITableViewCell *)cell
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)cancelButtonTap:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *) titleArray
{
    if( !_titleArray )
    {
        _titleArray = @[@"Name", @"Categories", @"Start Time", @"End Time", @"Description", @"Location"];
    }
    
    return _titleArray;
}

- (Event *)event
{
    if( !_event )
    {
        _event = [[Event alloc] init];
    }
    
    return _event;
}
@end
