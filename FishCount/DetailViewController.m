//
//  DetailViewController.m
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import <RestKit/RestKit.h>
#import "ScheduleViewController.h"
#import "ScheduleFormDataSource.h"
#import "Visit.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize visit = _visit,
            sigImage = _sigImage,
            getSignatureButton = _getSignatureButton,
            viewScheduleButton = _viewScheduleButton,
            visitorCounterButton = _visitorCounterButton,
            masterPopoverController = _masterPopoverController;

-(void) didClickScheduleButton:(id) sender{
    ScheduleFormDataSource *ds = [[ScheduleFormDataSource alloc] initWithModel:visit];
    ScheduleViewController *schedule = [[ScheduleViewController alloc] initWithNibName:nil bundle:nil formDataSource:ds];
    schedule.delegate = self;
    
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:schedule];
    ctrl.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:ctrl animated:YES];
}

-(void) didClickSignatureButton:(id) sender{
    JBSignatureController *signatureController = [[JBSignatureController alloc] init];
	signatureController.delegate = self;
    
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:signatureController];
    ctrl.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:ctrl animated:YES];
}

-(void) didClickVisitorCounterButton:(id) sender{
    VisitorCounterViewController *visitCounterController = [[VisitorCounterViewController alloc] init];
    visitCounterController.delegate = self;
    visitCounterController.providedStudentCount = self.visit.studentCount;
    visitCounterController.providedChaperoneCount = self.visit.chaperoneCount;
    visitCounterController.providedExtraChaperoneCount = self.visit.extraChaperoneCount;
    [visitCounterController setCountsForStudents:[self.visit.actualStudentCount intValue] andChaps:[self.visit.actualChaperoneCount intValue] andExtraChaps:[self.visit.actualExtraChaperoneCount intValue]];
    
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:visitCounterController];
    ctrl.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:ctrl animated:YES];
}

-(void) didClickSaveButton:(id) sender{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Finalize Record"];
	[alert setMessage:@"Do you want to finalize this record? By finalizing a record it will be saved to the database upon syncing the iPad. Only finalize if you are responsible for this school!"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"No"];
	[alert addButtonWithTitle:@"Yes"];
	[alert show];
}

- (void)loadView 
{
	[super loadView];
    
    self.title = @"Georgia Aquarium Educator Assistant";

    studentCount.keyboardType = UIKeyboardTypeNumberPad;
    chapCount.keyboardType = UIKeyboardTypeNumberPad;
    extChapCount.keyboardType = UIKeyboardTypeNumberPad;
    
    // Add signature button
    self.getSignatureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.getSignatureButton setTitle:@"Add Signature" forState:UIControlStateNormal];
	[self.getSignatureButton sizeToFit];
	[self.getSignatureButton setFrame:CGRectMake(40.0f, 
										   640.0f, 
										   self.getSignatureButton.frame.size.width, 
										   self.getSignatureButton.frame.size.height)];
	[self.getSignatureButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [self.getSignatureButton setHidden:YES];

    // Add schedule button
    self.viewScheduleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.viewScheduleButton setTitle:@"View Schedule" forState:UIControlStateNormal];
	[self.viewScheduleButton sizeToFit];
	[self.viewScheduleButton setFrame:CGRectMake(200.0f, 
                                                 640.0f, 
                                                 self.viewScheduleButton.frame.size.width, 
                                                 self.viewScheduleButton.frame.size.height)];
	[self.viewScheduleButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [self.viewScheduleButton setHidden:YES];

    // Add visitor counter button
    self.visitorCounterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.visitorCounterButton setTitle:@"Visitor Counter" forState:UIControlStateNormal];
	[self.visitorCounterButton sizeToFit];
	[self.visitorCounterButton setFrame:CGRectMake(360.0f, 
                                                 640.0f, 
                                                 self.visitorCounterButton.frame.size.width, 
                                                 self.visitorCounterButton.frame.size.height)];
	[self.visitorCounterButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [self.visitorCounterButton setHidden:YES];

    // Add signature image
    self.sigImage = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 740.0f, 300.f, 100.0f)];
    [self.sigImage setHidden:YES];
}

-(void) loadNewModel:(Visit*)visitModel{
    // Handle signature image
    if(visitModel.signatureImage != nil){
//        [self.sigImage setImage:_visit.signatureImage];
//        [self.sigImage setHidden:NO];
    }
    else{
//        [self.sigImage setImage:nil];
//        [self.sigImage setHidden:YES];
    }
    
    // Misc
//    [self.getSignatureButton setHidden:NO];
//    [self.viewScheduleButton setHidden:NO];
//    [self.visitorCounterButton setHidden:NO];
    
    self.title = visitModel.school;
    time.text = [visitModel formattedDate];
    schoolName.text = visitModel.school;
    leadTeacher.text = visitModel.leadTeacher;
    state.text = visitModel.state;
    county.text = visitModel.county;
    payment.text = visitModel.paymentType;
    type.text = visitModel.theType;
    program.text = visitModel.program;
    curbNotes.text = visitModel.curbNotes;
    studentCount.text = @"0";
    chapCount.text = @"0";
    extChapCount.text = @"0";
    studentProjected.text = [NSString stringWithFormat:@"Projected: %@", visitModel.studentCount];
    chapProjected.text = [NSString stringWithFormat:@"Projected: %@", visitModel.chaperoneCount];
    extChapProjected.text = [NSString stringWithFormat:@"Projected: %@", visitModel.extraChaperoneCount];

    _visit = visitModel;
}

-(void) configureView{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.getSignatureButton addTarget:self action:@selector(didClickSignatureButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.viewScheduleButton addTarget:self action:@selector(didClickScheduleButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.visitorCounterButton addTarget:self action:@selector(didClickVisitorCounterButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tableView addSubview:self.sigImage];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self.sigImage setHidden:YES];
}

- (void)viewDidUnload
{
    time = nil;
    schoolName = nil;
    leadTeacher = nil;
    state = nil;
    county = nil;
    payment = nil;
    type = nil;
    program = nil;
    curbNotes = nil;
    studentCount = nil;
    chapCount = nil;
    extChapCount = nil;
    studentProjected = nil;
    chapProjected = nil;
    extChapProjected = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Schools", @"Schools");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Finalize"
																	style:UIBarButtonItemStyleDone 
																   target:self 
																   action:@selector(didClickSaveButton:)];
    [self.navigationItem setRightBarButtonItem:saveButton animated:YES];
    
    
    self.masterPopoverController = nil;
}

#pragma mark -
#pragma mark ModalViewControllerDelegate

- (void)didDismissModalView {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark JBSignatureControllerDelegate

-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(JBSignatureController *)sender
{
    [self.sigImage setImage:signatureImage];
    [self.sigImage setHidden:NO];
    
    visit.signatureImage = signatureImage;
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)signatureCancelled:(JBSignatureController *)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [sender clearSignature];
}

#pragma mark -
#pragma mark VisitorCounterViewControllerDelegate

- (void)didDismissVisitorModalViewWithCounterData:(NSDictionary *)counterData{
//    Visit *model = (Visit*) self.formDataSource.model;
//    model.actualStudentCount = [counterData objectForKey:@"studentCount"];
//    model.actualChaperoneCount = [counterData objectForKey:@"chaperoneCount"];
//    model.actualExtraChaperoneCount = [counterData objectForKey:@"extraChaperoneCount"];

//    [self.tableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Todo" message:@"Flag record as dirty and in need of a sync!" delegate:nil cancelButtonTitle:@"Aight" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark Table Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0) [time becomeFirstResponder];
        else if(indexPath.row == 1) [schoolName becomeFirstResponder];
        else if(indexPath.row == 2) [leadTeacher becomeFirstResponder];
        else if(indexPath.row == 3) [state becomeFirstResponder];
        else if(indexPath.row == 4) [county becomeFirstResponder];
        else if(indexPath.row == 5) [payment becomeFirstResponder];
        else if(indexPath.row == 6) [type becomeFirstResponder];
        else if(indexPath.row == 7) [program becomeFirstResponder];
        else if(indexPath.row == 8) [curbNotes becomeFirstResponder];
    }
    else{
        if(indexPath.row == 0) [studentCount becomeFirstResponder];
        else if(indexPath.row == 1) [chapCount becomeFirstResponder];
        else if(indexPath.row == 2) [extChapCount becomeFirstResponder];
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return section == 1 ? 9 : 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTime"];
//    return cell;
//}

@end
