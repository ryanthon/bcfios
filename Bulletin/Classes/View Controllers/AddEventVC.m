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
#import "DatePickerCell.h"

static NSString *kTextCellID    = @"textCell";
static NSString *kDateCellID    = @"timeCell";
static NSString *kPickerCellID  = @"pickerCell";
static NSString *kSegueCellID   = @"Cell";

@interface AddEventVC () <TextFieldCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSArray           *titleArray;
@property (strong, nonatomic) UITextField       *currentEditingField;
@property (strong, nonatomic) UIView            *headerView;
@property (strong, nonatomic) UIImageView       *eventImage;
@property (strong, nonatomic) UILabel           *chooseLabel;
@property (strong, nonatomic) UIImage           *chosenImage;
@property (strong, nonatomic) NSIndexPath       *datePickerIndexPath;
@property (strong, nonatomic) NSDateFormatter   *dateFormatter;

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
    if ( [self hasInlineDatePicker] )
    {
        return self.titleArray.count + 1;
    }
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [self cellIDForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSInteger row = indexPath.row;
    if ( [self hasInlineDatePicker] && self.datePickerIndexPath.row < indexPath.row)
    {
        row--;
    }
    
    if( [cellID isEqualToString:kDateCellID] )
    {
        cell.textLabel.text = self.titleArray[row];
        
        if( row == 2 )
        {
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.event.startDate];
            
            if( !self.event.startDate )
            {
                cell.detailTextLabel.text = @"Select Date";
            }
        }
        else
        {
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.event.endDate];
            
            if( !self.event.endDate )
            {
                cell.detailTextLabel.text = @"Select Date";
            }
        }
    }
    
    else if( [cellID isEqualToString:kTextCellID] )
    {
        cell.textLabel.text = self.titleArray[row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TextFieldCell *textCell = (TextFieldCell *)cell;
        textCell.textField.placeholder = @"Enter Event Name";
        textCell.delegate = self;
    }
    
    else if( [cellID isEqualToString:kPickerCellID] )
    {
        DatePickerCell *datePickerCell = (DatePickerCell *)cell;
        [datePickerCell.datePicker addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventValueChanged];
    }
    
    else if( [cellID isEqualToString:kSegueCellID] )
    {
        cell.textLabel.text = self.titleArray[row];
        if( self.event.description )
        {
            cell.detailTextLabel.text = self.event.description;
        }
    }
    
    return cell;
}

- (NSString *)cellIDForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = kSegueCellID;
    
    if ( [self indexPathHasPicker:indexPath] )
    {
        cellID = kPickerCellID;
    }
    else if ( [self indexPathHasDate:indexPath] )
    {
        cellID = kDateCellID;
    }
    else if( indexPath.row == 0 )
    {
        cellID = kTextCellID;
    }
    
    return cellID;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self indexPathHasDate:indexPath] )
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }
    
    else
    {
        NSInteger row = indexPath.row;
        if( [self hasInlineDatePicker] )
        {
            row--;
        }
        
        switch( row )
        {
            case 3: [self performSegueWithIdentifier:@"categories" sender:nil];  break;
            case 4: [self performSegueWithIdentifier:@"description" sender:nil]; break;
            case 5: [self performSegueWithIdentifier:@"location" sender:nil];    break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ( [self indexPathHasPicker:indexPath] ? 162 : self.tableView.rowHeight );
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger targetedRow = indexPath.row + 1;
    
    UITableViewCell *checkDatePickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    
    return ( [checkDatePickerCell isKindOfClass:[DatePickerCell class]] );
}

- (BOOL)hasInlineDatePicker
{
    return ( self.datePickerIndexPath != nil );
}

- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ( [self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row );
}

- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ( ( indexPath.row == 1 ) ||
         ( indexPath.row == 2 || ( [self hasInlineDatePicker] && ( indexPath.row == 3 ) ) ) )
    {
        hasDate = YES;
    }
    
    return hasDate;
}

- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0] ];
    
    // check if 'indexPath' has an attached date picker below it
    if ( [self hasPickerForIndexPath:indexPath] )
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    
    if ( [self hasInlineDatePicker] )
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = ( self.datePickerIndexPath.row - 1 == indexPath.row );
    
    // remove any date picker cell if it exists
    if ( [self hasInlineDatePicker] )
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if ( !sameCellClicked )
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
}

- (void)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    if( targetedCellIndexPath.row == 2 )
    {
        self.event.startDate = targetedDatePicker.date;
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    }
    else
    {
        self.event.endDate = targetedDatePicker.date;
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [self hasInlineDatePicker] )
    {
        [self displayInlineDatePickerForRowAtIndexPath:[NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0]];
    }
    
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
    self.chosenImage = chosenImage;
    [self.chooseLabel removeFromSuperview];
    
    /*[[APIManager sharedManager] authorizePOSTrequest:@"addImg" forImage:chosenImage response:^( NSError *error, id response )
     {
         if( error )
         {
             NSLog(@"ERROR");
         }
         else
         {
             NSLog(@"SUCCESS");
         }
     }];*/
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)textField:(UITextField *)textField didBeginEditingInCell:(UITableViewCell *)cell
{
    self.currentEditingField = textField;
    
    if( [self hasInlineDatePicker] )
    {
        [self displayInlineDatePickerForRowAtIndexPath:[NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0]];
    }
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
        _titleArray = @[@"Name", @"Start Date", @"End Date", @"Categories", @"Description", @"Location"];
    }
    
    return _titleArray;
}

- (NSDateFormatter *)dateFormatter
{
    if( !_dateFormatter )
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"M/d/yy hh:mm a";
    }
    
    return _dateFormatter;
}

- (UIView *)headerView
{
    if( !_headerView )
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
        [_headerView.layer setShadowOpacity:0.8];
        [_headerView.layer setShadowRadius:2.0];
        [_headerView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        
        UIButton *chooseImageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        chooseImageButton.backgroundColor = [UIColor whiteColor];
        [chooseImageButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
        [chooseImageButton addSubview:self.eventImage];
        [chooseImageButton addSubview:self.chooseLabel];
        
        [_headerView addSubview:chooseImageButton];
    }
    
    return _headerView;
}

- (UIImageView *)eventImage
{
    if( !_eventImage )
    {
        _eventImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    }
    
    return _eventImage;
}

- (UILabel *)chooseLabel
{
    if( !_chooseLabel )
    {
        _chooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _chooseLabel.numberOfLines = 0;
        _chooseLabel.text = @"Choose\nan\nImage";
        _chooseLabel.textColor = [UIColor lightGrayColor];
        _chooseLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _chooseLabel;
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
