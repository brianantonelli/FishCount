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
    kTypeProgram
} PickerType;

@interface DetailViewController : UITableViewController <UISplitViewControllerDelegate, ModalViewControllerDelegate, JBSignatureControllerDelegate, VisitorCounterViewControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    Visit *visit;
    IBOutlet UITextField *time;
    IBOutlet UITextField *schoolName;
    IBOutlet UITextField *leadTeacher;
    IBOutlet UILabel *state; // TODO: county
    IBOutlet UITextField *payment;
    IBOutlet UILabel *type; // TODO: program
    IBOutlet UITextField *curbNotes;
    IBOutlet UITextField *studentCount;
    IBOutlet UITextField *chapCount;
    IBOutlet UITextField *extChapCount;
    IBOutlet UILabel *studentProjected;
    IBOutlet UILabel *chapProjected;
    IBOutlet UILabel *extChapProjected;
    UIPopoverController *pickerPopoverController;
    PickerType pickerType;
    NSArray *states;
    NSArray *counties;
    NSArray *programs;
    NSArray *types;
    NSArray *huh;
}

-(void) didClickScheduleButton:(id) sender;
-(void) didClickSignatureButton:(id) sender;
-(void) didClickVisitorCounterButton:(id) sender;
-(void) didClickSaveButton:(id) sender;
-(void) loadNewModel:(Visit*)visit;

-(void) presentStatePicker;
-(void) presentTypePicker;
-(void) displayPicker;
-(void) okayButtonPressed;
-(void) cancelButtonPressed;

@property(nonatomic, strong) Visit *visit;
@property(nonatomic, strong) UIImageView *sigImage;
@property(nonatomic, strong) UIButton *getSignatureButton;
@property(nonatomic, strong) UIButton *viewScheduleButton;
@property(nonatomic, strong) UIButton *visitorCounterButton;
@property(nonatomic, strong) UIPopoverController *pickerPopoverController;
@property(nonatomic, strong) NSArray *states;
@property(nonatomic, strong) NSArray *counties;
@property(nonatomic, strong) NSArray *programs;
@property(nonatomic, strong) NSArray *types;
@property(nonatomic, strong) NSArray *huh;
@end