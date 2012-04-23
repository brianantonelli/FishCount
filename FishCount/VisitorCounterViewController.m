//
//  VisitorCounterViewController.m
//  FishCount
//
//  Created by Antonelli Brian on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VisitorCounterViewController.h"

@implementation VisitorCounterViewController

@synthesize delegate, addStudentButton, addChaperoneButton, addExtraChaperoneButton, studentCountLabel, chaperoneCountLabel, extraChaperoneCountLabel, studentCountTextField, chaperoneCountTextField, extraChaperoneCountTextField, providedStudentCountLabel, providedChaperoneCountLabel, providedExtraChaperoneCountLabel, removeStudentButton, removeChaperoneButton, removeExtraChaperoneButton, providedStudentCount, providedChaperoneCount, providedExtraChaperoneCount;

-(void) didClickAddStudentButton:(id) sender{
    self.studentCountTextField.text = [NSString stringWithFormat:@"%d", ++studentCount];
}

-(void) didClickRemoveStudentButton:(id) sender{
    if(studentCount > 0) studentCount--;
    self.studentCountTextField.text = [NSString stringWithFormat:@"%d", studentCount];
}

-(void) didClickAddChaperoneButton:(id) sender{
    self.chaperoneCountTextField.text = [NSString stringWithFormat:@"%d", ++chaperoneCount];
}

-(void) didClickRemoveChaperoneButton:(id) sender{
    if(chaperoneCount > 0) chaperoneCount--;
    self.chaperoneCountTextField.text = [NSString stringWithFormat:@"%d", chaperoneCount];
}

-(void) didClickAddExtraChaperoneButton:(id) sender{
    self.extraChaperoneCountTextField.text = [NSString stringWithFormat:@"%d", ++extraChaperoneCount];
}

-(void) didCLickRemoveExtraChaperoneButton:(id) sender{
    if(extraChaperoneCount > 0) extraChaperoneCount--;
    self.extraChaperoneCountTextField.text = [NSString stringWithFormat:@"%d", extraChaperoneCount];
}

-(void) didClickConfirmButton:(id) sender{
    NSDictionary *counterData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:studentCount], @"studentCount",
                                 [NSNumber numberWithInt:chaperoneCount], @"chaperoneCount",
                                 [NSNumber numberWithInt:extraChaperoneCount], @"extraChaperoneCount", nil];
    
    [self.delegate didDismissVisitorModalViewWithCounterData:counterData];
}

-(void) setCountsForStudents:(int)studCount andChaps:(int)chapCount andExtraChaps:(int)extraChaps{
    studentCount = studCount;
    chaperoneCount = chapCount;
    extraChaperoneCount = extraChaps;
}

-(void) studentTextFieldChanged{
    studentCount = [studentCountTextField.text intValue];
}

-(void) chaperoneTextFieldChanged{
    chaperoneCount = [chaperoneCountTextField.text intValue];
}

-(void) extraChaperoneTextFieldChanged{
    extraChaperoneCount = [extraChaperoneCountTextField.text intValue];
}


#pragma mark -
#pragma mark View

-(void)loadView {
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Confirm"
																	style:UIBarButtonItemStyleDone 
																   target:self 
																   action:@selector(didClickConfirmButton:)] autorelease];
    [self.navigationItem setRightBarButtonItem:saveButton animated:YES];
	
    self.title = @"Visitor Counter";
    
    // Field headers
    self.studentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 40.0f, 100.0f, 42.0f)];
    self.studentCountLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.studentCountLabel.textAlignment = UITextAlignmentCenter;
    self.studentCountLabel.backgroundColor = [UIColor clearColor];
    self.studentCountLabel.text = @"Student";
    
    self.chaperoneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(220.0f, 40.0f, 100.0f, 42.0f)];
    self.chaperoneCountLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.chaperoneCountLabel.textAlignment = UITextAlignmentCenter;
    self.chaperoneCountLabel.backgroundColor = [UIColor clearColor];
    self.chaperoneCountLabel.text = @"Chaperone";
    
    self.extraChaperoneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(400.0f, 40.0f, 100.0f, 42.0f)];
    self.extraChaperoneCountLabel.textAlignment = UITextAlignmentCenter;
    self.extraChaperoneCountLabel.font = [UIFont boldSystemFontOfSize:16];
    self.extraChaperoneCountLabel.backgroundColor = [UIColor clearColor];
    self.extraChaperoneCountLabel.text = @"Extra Chap.";

    // Counters
    self.studentCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(40.0f, 80.0f, 100.0f, 42.0f)];
    self.studentCountTextField.font = [UIFont boldSystemFontOfSize:32.0f];
    self.studentCountTextField.textAlignment = UITextAlignmentCenter;
    self.studentCountTextField.backgroundColor = [UIColor whiteColor];
    self.studentCountTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.studentCountTextField.text = [NSString stringWithFormat:@"%d", studentCount];
    self.studentCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.studentCountTextField addTarget:self action:@selector(studentTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    self.chaperoneCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(220.0f, 80.0f, 100.0f, 42.0f)];
    self.chaperoneCountTextField.font = [UIFont boldSystemFontOfSize:32.0f];
    self.chaperoneCountTextField.textAlignment = UITextAlignmentCenter;
    self.chaperoneCountTextField.backgroundColor = [UIColor whiteColor];
    self.chaperoneCountTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.chaperoneCountTextField.text = [NSString stringWithFormat:@"%d", extraChaperoneCount];
    self.chaperoneCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.chaperoneCountTextField addTarget:self action:@selector(chaperoneTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    self.extraChaperoneCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(400.0f, 80.0f, 100.0f, 42.0f)];
    self.extraChaperoneCountTextField.textAlignment = UITextAlignmentCenter;
    self.extraChaperoneCountTextField.font = [UIFont boldSystemFontOfSize:32.0f];
    self.extraChaperoneCountTextField.backgroundColor = [UIColor whiteColor];
    self.extraChaperoneCountTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.extraChaperoneCountTextField.text = [NSString stringWithFormat:@"%d", chaperoneCount];
    self.extraChaperoneCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.extraChaperoneCountTextField addTarget:self action:@selector(extraChaperoneTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    // Provided Counter Labels
    self.providedStudentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 110.0f, 100.0f, 42.0f)];
    self.providedStudentCountLabel.textAlignment = UITextAlignmentRight;
    self.providedStudentCountLabel.font = [UIFont systemFontOfSize:12.0f];
    self.providedStudentCountLabel.backgroundColor = [UIColor clearColor];
    self.providedStudentCountLabel.text = [NSString stringWithFormat:@"Est. %d", [providedStudentCount intValue]];

    self.providedChaperoneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(220.0f, 110.0f, 100.0f, 42.0f)];
    self.providedChaperoneCountLabel.textAlignment = UITextAlignmentRight;
    self.providedChaperoneCountLabel.font = [UIFont systemFontOfSize:12.0f];
    self.providedChaperoneCountLabel.backgroundColor = [UIColor clearColor];
    self.providedChaperoneCountLabel.text = [NSString stringWithFormat:@"Est. %d", [providedChaperoneCount intValue]];

    self.providedExtraChaperoneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(400.0f, 110.0f, 100.0f, 42.0f)];
    self.providedExtraChaperoneCountLabel.textAlignment = UITextAlignmentRight;
    self.providedExtraChaperoneCountLabel.font = [UIFont systemFontOfSize:12.0f];
    self.providedExtraChaperoneCountLabel.backgroundColor = [UIColor clearColor];
    self.providedExtraChaperoneCountLabel.text = [NSString stringWithFormat:@"Est. %d", [providedExtraChaperoneCount intValue]];

    
    // Add Buttons
    self.addStudentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.addStudentButton setTitle:@"Add" forState:UIControlStateNormal];
	[self.addStudentButton setFrame:CGRectMake(40.0f, 180.0f, 100.0f, 42.0f)];
	[self.addStudentButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];

    self.addChaperoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.addChaperoneButton setTitle:@"Add" forState:UIControlStateNormal];
	[self.addChaperoneButton setFrame:CGRectMake(220.0f, 180.0f, 100.0f, 42.0f)];
	[self.addChaperoneButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];

    self.addExtraChaperoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.addExtraChaperoneButton setTitle:@"Add" forState:UIControlStateNormal];
	[self.addExtraChaperoneButton setFrame:CGRectMake(400.0f, 180.0f, 100.0f, 42.0f)];
	[self.addExtraChaperoneButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    
    // Remove buttons
    self.removeStudentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.removeStudentButton setTitle:@"Remove" forState:UIControlStateNormal];
	[self.removeStudentButton setFrame:CGRectMake(40.0f, 240.0f, 100.0f, 42.0f)];
	[self.removeStudentButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    
    self.removeChaperoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.removeChaperoneButton setTitle:@"Remove" forState:UIControlStateNormal];
	[self.removeChaperoneButton setFrame:CGRectMake(220.0f, 240.0f, 100.0f, 42.0f)];
	[self.removeChaperoneButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    
    self.removeExtraChaperoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.removeExtraChaperoneButton setTitle:@"Remove" forState:UIControlStateNormal];
	[self.removeExtraChaperoneButton setFrame:CGRectMake(400.0f, 240.0f, 100.0f, 42.0f)];
	[self.removeExtraChaperoneButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
}

-(void)viewDidLoad {
    // Fields
    [self.view addSubview:self.studentCountTextField];
    [self.view addSubview:self.chaperoneCountTextField];    
    [self.view addSubview:self.extraChaperoneCountTextField];   

    // Labels
    [self.view addSubview:self.studentCountLabel];
    [self.view addSubview:self.chaperoneCountLabel];    
    [self.view addSubview:self.extraChaperoneCountLabel];   
    [self.view addSubview:self.providedStudentCountLabel];
    [self.view addSubview:self.providedChaperoneCountLabel];
    [self.view addSubview:self.providedExtraChaperoneCountLabel];
    
    // Add buttons
    [self.view addSubview:self.addStudentButton];
    [self.addStudentButton addTarget:self action:@selector(didClickAddStudentButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addChaperoneButton];
    [self.addChaperoneButton addTarget:self action:@selector(didClickAddChaperoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addExtraChaperoneButton];
    [self.addExtraChaperoneButton addTarget:self action:@selector(didClickAddExtraChaperoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Remove buttons
    [self.view addSubview:self.removeStudentButton];
    [self.removeStudentButton addTarget:self action:@selector(didClickRemoveStudentButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.removeChaperoneButton];
    [self.removeChaperoneButton addTarget:self action:@selector(didClickRemoveChaperoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.removeExtraChaperoneButton];
    [self.removeExtraChaperoneButton addTarget:self action:@selector(didCLickRemoveExtraChaperoneButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 	
	return YES;
}


#pragma mark -
#pragma mark Memory Management

-(void) dealloc{
    [studentCountTextField release];
    [chaperoneCountTextField release];
    [extraChaperoneCountTextField release];
    [addStudentButton release];
    [addChaperoneButton release];
    [addExtraChaperoneButton release];
    [studentCountLabel release];
    [chaperoneCountLabel release];
    [extraChaperoneCountLabel release];
    [removeStudentButton release];
    [removeChaperoneButton release];
    [removeExtraChaperoneButton release];
    [providedStudentCount release];
    [providedChaperoneCount release];
    [providedExtraChaperoneCount release];
    [providedStudentCountLabel release];
    [providedChaperoneCountLabel release];
    [providedExtraChaperoneCount release];
    
    [super dealloc];
}

@end
