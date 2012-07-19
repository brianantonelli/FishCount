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

//  Created by Antonelli Brian on 4/21/12.

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
