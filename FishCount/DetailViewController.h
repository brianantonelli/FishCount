/**
 
 FishCount
 Copyright (C) 2012 Brian Antonelli
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 
 */

//  Created by Antonelli Brian on 4/17/12.

#import <UIKit/UIKit.h>
//#import <IBAForms/IBAFormViewController.h>
#import "ScheduleViewController.h"
#import "Visit.h"
#import "JBSignatureController.h"
//#import "VisitFormDataSource.h"
#import "VisitorCounterViewController.h"

@protocol DetailViewControllerDelegate <NSObject>

@required

- (void)didSave;

@end

typedef enum {
    kTime,
    kStateCounty,
    kTypeProgram,
    kPayment
} PickerType;

@interface DetailViewController : UITableViewController <UISplitViewControllerDelegate, ModalViewControllerDelegate, JBSignatureControllerDelegate, VisitorCounterViewControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
    Visit *visit;
    IBOutlet UILabel *time;
    IBOutlet UITextField *schoolName;
    IBOutlet UITextField *leadTeacher;
    IBOutlet UILabel *state;
    IBOutlet UILabel *payment;
    IBOutlet UILabel *type;
    IBOutlet UITextField *curbNotes;
    IBOutlet UITextField *studentCount;
    IBOutlet UITextField *chapCount;
    IBOutlet UITextField *extChapCount;
    IBOutlet UILabel *studentProjected;
    IBOutlet UILabel *chapProjected;
    IBOutlet UILabel *extChapProjected;
    IBOutlet UITableViewCell *buttonsCell;
    IBOutlet UITableViewCell *sigCell;
    IBOutlet UIButton *getSignatureButton;
    IBOutlet UIButton *viewScheduleButton;
    IBOutlet UIButton *visitorCounterButton;
    IBOutlet UIImageView *sigImage;
    UIPopoverController *pickerPopoverController;
    UIPickerView *pickerView;
    UIDatePicker *datePickerView;
    PickerType pickerType;
    NSArray *states;
    NSArray *counties;
    NSArray *payments;
    NSArray *types;
    NSArray *programs;
    id<DetailViewControllerDelegate> __weak delegate;
}

-(IBAction) didClickScheduleButton:(id) sender;
-(IBAction) didClickSignatureButton:(id) sender;
-(IBAction) didClickVisitorCounterButton:(id) sender;
-(IBAction) didClickSaveButton:(id) sender;
-(void) loadNewModel:(Visit*)visit;

-(void) presentStatePicker;
-(void) presentTypePicker;
-(void) displayDatePicker;
-(void) displayPicker;
-(void) displayPickerPopOverForPickerView:(UIView*)thePickerView;
-(void) okayButtonPressed;
-(void) cancelButtonPressed;

@property(nonatomic, strong) Visit *visit;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIDatePicker *datePickerView;
@property(nonatomic, strong) UIPopoverController *pickerPopoverController;
@property(nonatomic, strong) NSArray *states;
@property(nonatomic, strong) NSArray *counties;
@property(nonatomic, strong) NSArray *programs;
@property(nonatomic, strong) NSArray *types;
@property(nonatomic, strong) NSArray *payments;
@property(nonatomic, weak) id<DetailViewControllerDelegate> delegate;
@end