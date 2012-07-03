//
//  VisitorCounterViewController.m
//  FishCount
//
//  Created by Antonelli Brian on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VisitorCounterViewController.h"

@implementation VisitorCounterViewController

@synthesize delegate;


-(IBAction) didClickConfirmButton:(id) sender{
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

-(void) setProvidedCountsForStudents:(NSNumber*)studCount andChaps:(NSNumber*)chapCount andExtraChaps:(NSNumber*)extraChaps{
    providedStudentCount = studCount;
    providedChaperoneCount = chapCount;
    providedExtraChaperoneCount = extraChaps;
}


-(IBAction) studentTextFieldChanged{
    studentCount = [studentInput.text intValue];
    studentStepper.value = studentCount;
}

-(IBAction) chaperoneTextFieldChanged{
    chaperoneCount = [chapInput.text intValue];
    chapStepper.value = chaperoneCount;
}

-(IBAction) extraChaperoneTextFieldChanged{
    extraChaperoneCount = [extraChapInput.text intValue];
    extraChapStepper.value = extraChaperoneCount;
}

- (IBAction)studentStepperChanged:(id)sender forEvent:(UIEvent *)event {
    studentCount = studentStepper.value;
    studentInput.text = [NSString stringWithFormat:@"%d", studentCount];
}

- (IBAction)chapStepperChanged:(id)sender forEvent:(UIEvent *)event {
    chaperoneCount = chapStepper.value;
    chapInput.text = [NSString stringWithFormat:@"%d", chaperoneCount];
}

- (IBAction)extraChapStepperChanged:(id)sender forEvent:(UIEvent *)event {
    extraChaperoneCount = extraChapStepper.value;
    extraChapInput.text = [NSString stringWithFormat:@"%d", extraChaperoneCount];
}


#pragma mark -
#pragma mark View

-(void)loadView {
    [super loadView];
    
    studentInput.text = [NSString stringWithFormat:@"%d", studentCount];
    chapInput.text = [NSString stringWithFormat:@"%d", chaperoneCount];
    extraChapInput.text = [NSString stringWithFormat:@"%d", extraChaperoneCount];
    studentEst.text = [NSString stringWithFormat:@"Est. %d", [providedStudentCount intValue]];
    chapEst.text = [NSString stringWithFormat:@"Est. %d", [providedChaperoneCount intValue]];
    extChapEst.text = [NSString stringWithFormat:@"Est. %d", [providedExtraChaperoneCount intValue]];
    
    studentStepper.value = studentCount;
    chapStepper.value = chaperoneCount;
    extraChapStepper.value = extraChaperoneCount;
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 	
	return YES;
}


#pragma mark -
#pragma mark Memory Management

- (void)viewDidUnload {
    studentInput = nil;
    chapInput = nil;
    extraChapInput = nil;
    studentEst = nil;
    chapEst = nil;
    extChapEst = nil;
    studentStepper = nil;
    chapStepper = nil;
    extraChapStepper = nil;
    [super viewDidUnload];
}

@end
