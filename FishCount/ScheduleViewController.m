//
//  ScheduleViewController.m
//  FishCount
//
//  Created by Antonelli Brian on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"

@implementation ScheduleViewController
@synthesize tableViewStyle, delegate;

- (void)loadView {
	[super loadView];
    
    self.title = @"Schedule";

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self
                                               action:@selector(dismissView:)] autorelease];

    UIView *view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:[view bounds] style:UITableViewStyleGrouped] autorelease];
	[tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:tableView];
	
	[view addSubview:tableView];
	[self setView:view];
}

- (void)dismissView:(id)sender {
    
    // Call the delegate to dismiss the modal view
    [delegate didDismissModalView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 
    // Return YES for supported orientations. 
    return YES;//UIInterfaceOrientationIsLandscape(interfaceOrientation); 
}
    



@end
