//
//  DetailViewController.h
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <IBAForms/IBAFormViewController.h>
#import "ScheduleViewController.h"
#import "Visit.h"
#import "JBSignatureController.h"
//#import "VisitFormDataSource.h"
#import "VisitorCounterViewController.h"

typedef enum {
    kStateCounty,
    kTypeProgram,
    kPayment
} PickerType;

@interface DetailViewController : UITableViewController <UISplitViewControllerDelegate, ModalViewControllerDelegate, JBSignatureControllerDelegate, VisitorCounterViewControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
    Visit *visit;
    Visit *tempVisit;
    IBOutlet UITextField *time;
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
    IBOutlet UIButton *getSignatureButton;
    IBOutlet UIButton *viewScheduleButton;
    IBOutlet UIButton *visitorCounterButton;
    UIPopoverController *pickerPopoverController;
    UIPickerView *pickerView;
    PickerType pickerType;
    NSArray *states;
    NSArray *counties;
    NSArray *payments;
    NSArray *types;
    NSArray *programs;
}

-(IBAction) didClickScheduleButton:(id) sender;
-(IBAction) didClickSignatureButton:(id) sender;
-(IBAction) didClickVisitorCounterButton:(id) sender;
-(void) didClickSaveButton:(id) sender;
-(void) loadNewModel:(Visit*)visit;

-(void) presentStatePicker;
-(void) presentTypePicker;
-(void) displayPicker;
-(void) okayButtonPressed;
-(void) cancelButtonPressed;

@property(nonatomic, strong) Visit *visit;
@property(nonatomic, strong) Visit *tempVisit;
@property(nonatomic, strong) UIImageView *sigImage;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIPopoverController *pickerPopoverController;
@property(nonatomic, strong) NSArray *states;
@property(nonatomic, strong) NSArray *counties;
@property(nonatomic, strong) NSArray *programs;
@property(nonatomic, strong) NSArray *types;
@property(nonatomic, strong) NSArray *payments;
@end