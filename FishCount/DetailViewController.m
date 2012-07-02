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

#define GEORGIA_INDEX 13;

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize visit = _visit,
            tempVisit = _tempVisit,
            sigImage = _sigImage,
            getSignatureButton = _getSignatureButton,
            viewScheduleButton = _viewScheduleButton,
            visitorCounterButton = _visitorCounterButton,
            masterPopoverController = _masterPopoverController,
            pickerPopoverController = _pickerPopoverController,
            pickerView = _pickerView,
            states = _states,
            counties = _counties,
            programs = _programs,
            types = _types,
            payments = _payments;


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
	[alert setTitle:@"Save Record"];
	[alert setMessage:@"Do you want to save this record? The record will be saved to the database upon syncing the iPad. Only save if you are responsible for this school!"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"No"];
	[alert addButtonWithTitle:@"Yes"];
	[alert show];
}

-(void) presentPaymentPicker{
    pickerType = kPayment;
    [self displayPicker];
}

-(void) presentStatePicker{
    pickerType = kStateCounty;
    [self displayPicker];
}

-(void) presentTypePicker{
    pickerType = kTypeProgram;
    [self displayPicker];
}

-(void) displayPicker{
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:popoverContent];
    
    UIView *popoverView = [[UIView alloc] init];
    popoverView.backgroundColor = [UIColor blackColor];
    
    popoverContent.view = popoverView;
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 264)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [popoverView addSubview:pickerView];
    
    pickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    pickerPopoverController.delegate = self;
    [pickerPopoverController setPopoverContentSize:CGSizeMake(320, 264) animated:YES];
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okayButtonPressed)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
    navigationController.navigationBar.topItem.leftBarButtonItem = cancelButton;
    navigationController.navigationBar.topItem.rightBarButtonItem = okButton;
    
    CGRect f = [self.tableView convertRect:extChapCount.frame fromView:self.view];
    
    NSLog(@"%f %f", f.origin.x, f.origin.y);
    
    [pickerPopoverController presentPopoverFromRect:state.frame inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES]; // TODO: Fix position
}

-(void) okayButtonPressed{
    if(pickerType == kStateCounty){
        _tempVisit.state = [_states objectAtIndex:[pickerView selectedRowInComponent:0]];
        state.text = _tempVisit.state;
        if([pickerView selectedRowInComponent:0] == 13){
            _tempVisit.county = [_counties objectAtIndex:[pickerView selectedRowInComponent:1]];
            state.text = [NSString stringWithFormat:@"%@ (%@ County)", _tempVisit.state, _tempVisit.county];
        }
        [_tempVisit flagAsDirty];
    }
    else if(pickerType == kTypeProgram){
        _tempVisit.theType = [_types objectAtIndex:[pickerView selectedRowInComponent:0]];
        type.text = _tempVisit.theType;
        if([pickerView selectedRowInComponent:0] == 0){
            _tempVisit.program = [_programs objectAtIndex:[pickerView selectedRowInComponent:1]];
            type.text = [NSString stringWithFormat:@"%@ (%@ Program)", _tempVisit.theType, _tempVisit.program];
            
        }
        [_tempVisit flagAsDirty];
    }
    else if(pickerType == kPayment){
        _tempVisit.paymentType = [_payments objectAtIndex:[pickerView selectedRowInComponent:0]];
        payment.text = _tempVisit.paymentType;
        [_tempVisit flagAsDirty];
    }
    
    [self.tableView reloadData];

    [pickerPopoverController dismissPopoverAnimated:YES];
}

-(void) cancelButtonPressed{
    [pickerPopoverController dismissPopoverAnimated:YES];
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
    
    _states = [NSArray arrayWithObjects:@"Canda", @"Mexico", @"International", @"", @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", nil];

    _counties = [NSArray arrayWithObjects: @"APS", @"Appling", @"Atkinson", @"Bacon", @"Baker", @"Baldwin", @"Banks", @"Barrow", @"Bartow", @"Ben Hill", @"Berrien", @"Bibb", @"Bleckley", @"Brantley", @"Brooks", @"Bryan", @"Bulloch", @"Burke", @"Butts", @"Calhoun", @"Camden", @"Candler", @"Carroll", @"Catoosa", @"Charlton", @"Chatham", @"Chattahoochee", @"Chattooga", @"Cherokee", @"Clarke", @"Clay", @"Clayton", @"Clinch", @"Cobb", @"Coffee", @"Colquitt", @"Columbia", @"Cook", @"Coweta", @"Crawford", @"Crisp", @"Dade", @"Dawson", @"Decatur", @"DeKalb", @"Dodge", @"Dooly", @"Dougherty", @"Douglas", @"Early", @"Echols", @"Effingham", @"Elbert", @"Emanuel", @"Evans", @"Fannin", @"Fayette", @"Floyd", @"Forsyth", @"Franklin", @"Fulton", @"Gilmer", @"Glascock", @"Glynn", @"Gordon", @"Grady", @"Greene", @"Gwinnett", @"Habersham", @"Hall", @"Hancock", @"Haralson", @"Harris", @"Hart", @"Heard", @"Henry", @"Houston", @"Irwin", @"Jackson", @"Jasper", @"Jeff Davis", @"Jefferson", @"Jenkins", @"Johnson", @"Jones", @"Lamar", @"Lanier", @"Laurens", @"Lee", @"Liberty", @"Lincoln", @"Long", @"Lowndes", @"Lumpkin", @"Macon", @"Madison", @"Marion", @"McDuffie", @"McIntosh", @"Meriwether", @"Miller", @"Mitchell", @"Monroe", @"Montgomery", @"Morgan", @"Murray", @"Muscogee", @"Newton", @"Oconee", @"Oglethorpe", @"Paulding", @"Peach", @"Pickens", @"Pierce", @"Pike", @"Polk", @"Pulaski", @"Putnam", @"Quitman", @"Rabun", @"Randolph", @"Richmond", @"Rockdale", @"Schley", @"Screven", @"Seminole", @"Spalding", @"Stephens", @"Stewart", @"Sumter", @"Talbot", @"Taliaferro", @"Tattnall", @"Taylor Webster", @"Telfair", @"Terrell", @"Thomas", @"Tift", @"Toombs", @"Towns", @"Treutlen", @"Troup", @"Turner", @"Twiggs", @"Union", @"Upson", @"Walker", @"Walton", @"Ware", @"Warren", @"Washington", @"Wayne", @"Wheeler", @"White", @"Whitfield", @"Wilcox", @"Wilkes", @"Wilkinson", @"Worth", nil];
    
    _payments = [NSArray arrayWithObjects:@"SEA", @"Paid", nil];

    _types = [NSArray arrayWithObjects:@"Instructor Lead", @"Aqua Adventure", nil];

    _programs = [NSArray arrayWithObjects:@"Aqua Tales", @"Hide and Seek", @"Bite Sized Basics", @"Sea Life Safari", @"Weird and Wild", @"Snack Attack", @"Undersea Investigators", @"Sharks In Depth", @"Aquarium 101", @"Animal Behavior", @"Discovery Lab - Genetics", @"Discovery Lab - Senses", @"Behind the Waterworks", @"Beyond the Classroom", nil];
    
    selectSchool.hidden = NO;
    // TODO: Figure out how to move label to the top and hide the other parts of the table
//    CGRect f = selectSchool.frame;
//    [selectSchool setFrame:CGRectMake(10.0f, 10.0f, f.size.width, f.size.height)];

}

-(void) loadNewModel:(Visit*)visitModel{
    selectSchool.hidden = YES;
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
    
    _visit = visitModel;
    _tempVisit = [Visit object];

    self.title = _visit.school;
    time.text = [_visit formattedDate];
    schoolName.text = _visit.school;
    leadTeacher.text = _visit.leadTeacher;
    state.text = [@"Georgia" isEqualToString:_visit.state] ? [NSString stringWithFormat:@"%@ (%@ County)", _visit.state, _visit.county] : _visit.state;
    type.text = [@"Instructor Lead" isEqualToString:_visit.theType] ? [NSString stringWithFormat:@"%@ (%@ Program)",_visit.theType, _visit.program] : _visit.paymentType;
    payment.text = _visit.paymentType;
    curbNotes.text = _visit.curbNotes;
    studentCount.text = @"0";
    chapCount.text = @"0";
    extChapCount.text = @"0";
    studentProjected.text = [NSString stringWithFormat:@"Projected: %@", _visit.studentCount];
    chapProjected.text = [NSString stringWithFormat:@"Projected: %@", _visit.chaperoneCount];
    extChapProjected.text = [NSString stringWithFormat:@"Projected: %@", _visit.extraChaperoneCount];
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
    payment = nil;
    type = nil;
    curbNotes = nil;
    studentCount = nil;
    chapCount = nil;
    extChapCount = nil;
    studentProjected = nil;
    chapProjected = nil;
    extChapProjected = nil;
    selectSchool = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerType == kStateCounty || pickerType == kTypeProgram) return 2;
    else return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerType == kStateCounty){
        return component == 0 ? [_states count] : [_counties count];
    }
    else if(pickerType == kTypeProgram){
        return component == 0 ? [_types count] : [_programs count];
    }
    else if(pickerType == kPayment){
        return [_payments count];
    }
    else{
        return 0;
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerType == kStateCounty){
        return component == 0 ? [_states objectAtIndex:row] : [thePickerView selectedRowInComponent:0] == 13 ? [_counties objectAtIndex:row] : @"";
    }
    else if(pickerType == kTypeProgram){
        return component == 0 ? [_types objectAtIndex:row] : [thePickerView selectedRowInComponent:0] == 0 ? [_programs objectAtIndex:row] : @"";
    }
    else if(pickerType == kPayment){
        return [_payments objectAtIndex:row];
    }
    else{
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerType == kStateCounty || pickerType == kTypeProgram){
        [thePickerView reloadComponent:1];
    }
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
    // TODO: This only shows in landscape, why not portrait?
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
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
        else if(indexPath.row == 3) [self presentStatePicker];
        else if(indexPath.row == 4) [self presentPaymentPicker];
        else if(indexPath.row == 5) [self presentTypePicker];
        else if(indexPath.row == 6) [curbNotes becomeFirstResponder];
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

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    // TODO: deal with time
    if(textField == schoolName && ![textField.text isEqualToString:_visit.school]){
        _visit.school = nil;
        _tempVisit.school = textField.text;
        [_tempVisit flagAsDirty];
        NSLog(@"changing temp school to %@", textField.text);
    }
    else if(textField == leadTeacher && ![textField.text isEqualToString:_visit.leadTeacher]){
        _visit.leadTeacher = nil;
        _tempVisit.leadTeacher = textField.text;
        [_tempVisit flagAsDirty];
        NSLog(@"changing lead to %@", textField.text);
    }
    else if(textField == curbNotes && ![textField.text isEqualToString:_visit.curbNotes]){
        _visit.curbNotes = nil;
        _tempVisit.curbNotes = textField.text;
        [_tempVisit flagAsDirty];
        NSLog(@"changing curb notes to %@", textField.text);
    }
    else if(textField == studentCount && (_visit.studentCount == nil || ![[numberFormatter numberFromString:textField.text] isEqualToNumber:_visit.studentCount])){
        _visit.studentCount = [NSNumber numberWithInt:0];
        _tempVisit.studentCount = [numberFormatter numberFromString:textField.text];
        [_tempVisit flagAsDirty];
        NSLog(@"changing student count to %@", textField.text);
    }
    else if(textField == chapCount && (_visit.chaperoneCount == nil || ![[numberFormatter numberFromString:textField.text] isEqualToNumber:_visit.chaperoneCount])){
        _visit.chaperoneCount = [NSNumber numberWithInt:0];
        _tempVisit.chaperoneCount = [numberFormatter numberFromString:textField.text];
        [_tempVisit flagAsDirty];
        NSLog(@"changing chap count to %@", textField.text);
    }
    else if(textField == extChapCount && (_visit.extraChaperoneCount == nil || ![[numberFormatter numberFromString:textField.text] isEqualToNumber:_visit.extraChaperoneCount])){
        _visit.extraChaperoneCount = [NSNumber numberWithInt:0];
        _tempVisit.extraChaperoneCount = [numberFormatter numberFromString:textField.text];
        [_tempVisit flagAsDirty];
        NSLog(@"changing ext chap count to %@", textField.text);
    }
}

@end
