//
//  ScheduleViewController.m
//  FishCount
//
//  Created by Antonelli Brian on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Visit.h"

@implementation ScheduleViewController
@synthesize delegate,
            visit = _visit;

- (IBAction)dismissView:(id)sender {
    
    // Call the delegate to dismiss the modal view
    [delegate didDismissModalView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    school.text = _visit.school;
    grade.text = _visit.grade;
    theatre.text = _visit.theatre;
    lunch.text = _visit.lunch;
    dolphin.text = _visit.dolphin;
    bus.text = _visit.bus;
    notes.text = _visit.notes;

    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}





- (void)viewDidUnload {
    school = nil;
    grade = nil;
    theatre = nil;
    lunch = nil;
    dolphin = nil;
    bus = nil;
    notes = nil;
    [super viewDidUnload];
}
@end
