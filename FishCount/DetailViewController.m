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
#import "Visit.h"
#import "MasterViewController.h"

#define GEORGIA_INDEX 13;

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize visit = _visit,
            masterPopoverController = _masterPopoverController,
            pickerPopoverController = _pickerPopoverController,
            pickerView = _pickerView,
            states = _states,
            counties = _counties,
            programs = _programs,
            types = _types,
            payments = _payments,
            delegate;


-(IBAction) didClickScheduleButton:(id) sender{
    [self performSegueWithIdentifier:@"scheduleSegue" sender:self];
}

-(IBAction) didClickSignatureButton:(id) sender{
    JBSignatureController *signatureController = [[JBSignatureController alloc] init];
	signatureController.delegate = self;
    
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:signatureController];
    ctrl.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:ctrl animated:YES];
}

-(IBAction) didClickVisitorCounterButton:(id) sender{
    [self performSegueWithIdentifier:@"modalVisitorCounterSegue" sender:self];
}

-(IBAction) didClickSaveButton:(id) sender{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Save Record"];
	[alert setMessage:@"Do you want to save this record? The record will be saved to the database upon syncing the iPad. Only save if you are responsible for this school!"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"No"];
	[alert addButtonWithTitle:@"Yes"];
    [self.view endEditing:TRUE];
	[alert show];
}

-(void) presentPaymentPicker{
    pickerType = kPayment;
    [self displayPicker];
    
    for(int i=0; i<[_payments count]; i++){
        NSString *pymt = [_payments objectAtIndex:i];
        if([pymt isEqualToString:_visit.paymentType]){
            [pickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

-(void) presentStatePicker{
    pickerType = kStateCounty;
    [self displayPicker];

    for(int i=0; i<[_states count]; i++){
        NSString *st = [_states objectAtIndex:i];
        if([st isEqualToString:_visit.state]){
            [pickerView selectRow:i inComponent:0 animated:YES];
            
            if(i == 13){
                for(int x=0; x<[_counties count]; x++){
                    NSString *cnty = [_counties objectAtIndex:x];
                    if([cnty isEqualToString:_visit.county]){
                        [pickerView selectRow:x inComponent:1 animated:YES];
                        break;
                    }
                }
            }
            break;
        }
    }
}

-(void) presentTypePicker{
    pickerType = kTypeProgram;
    [self displayPicker];
    
    for(int i=0; i<[_types count]; i++){
        NSString *typ = [_types objectAtIndex:i];
        if([typ isEqualToString:_visit.theType]){
            [pickerView selectRow:i inComponent:0 animated:YES];
            
            if(i == 0){
                for(int x=0; x<[_programs count]; x++){
                    NSString *prgm = [_programs objectAtIndex:x];
                    if([prgm isEqualToString:_visit.program]){
                        [pickerView selectRow:x inComponent:1 animated:YES];
                        break;
                    }
                }
            }
            // special edge case, if aqua adv is picked it displays the programs
            else{
                [pickerView reloadComponent:1];
            }
            break;
        }
    }
}

-(void) displayPicker{
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:popoverContent];
    
    UIView *popoverView = [[UIView alloc] init];
    popoverView.backgroundColor = [UIColor blackColor];
    
    popoverContent.view = popoverView;
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 360, 264)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [popoverView addSubview:pickerView];
    
    pickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    pickerPopoverController.delegate = self;
    [pickerPopoverController setPopoverContentSize:CGSizeMake(360, 264) animated:YES];
    
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okayButtonPressed)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
    navigationController.navigationBar.topItem.leftBarButtonItem = cancelButton;
    navigationController.navigationBar.topItem.rightBarButtonItem = okButton;
    
    CGRect rectInTableView;
    if(pickerType == kStateCounty){
        rectInTableView = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    }
    else if(pickerType == kTypeProgram){
        rectInTableView = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
    }
    else{
        rectInTableView = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
    }
    
    CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];

    [pickerPopoverController presentPopoverFromRect:rectInSuperview inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) okayButtonPressed{
    if(pickerType == kStateCounty){
        _visit.state = [_states objectAtIndex:[pickerView selectedRowInComponent:0]];
        state.text = _visit.state;
        if([pickerView selectedRowInComponent:0] == 13){
            _visit.county = [_counties objectAtIndex:[pickerView selectedRowInComponent:1]];
            state.text = [NSString stringWithFormat:@"%@ (%@ County)", _visit.state, _visit.county];
        }
        [_visit flagAsDirty:YES];
    }
    else if(pickerType == kTypeProgram){
        _visit.theType = [_types objectAtIndex:[pickerView selectedRowInComponent:0]];
        type.text = _visit.theType;
        if([pickerView selectedRowInComponent:0] == 0){
            _visit.program = [_programs objectAtIndex:[pickerView selectedRowInComponent:1]];
            type.text = [NSString stringWithFormat:@"%@ (%@ Program)", _visit.theType, _visit.program];
            
        }
        [_visit flagAsDirty:YES];
    }
    else if(pickerType == kPayment){
        _visit.paymentType = [_payments objectAtIndex:[pickerView selectedRowInComponent:0]];
        payment.text = _visit.paymentType;
        [_visit flagAsDirty:YES];
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
    
    _states = [NSArray arrayWithObjects:@"Canda", @"Mexico", @"International", @"", @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", nil];

    _counties = [NSArray arrayWithObjects: @"APS", @"Appling", @"Atkinson", @"Bacon", @"Baker", @"Baldwin", @"Banks", @"Barrow", @"Bartow", @"Ben Hill", @"Berrien", @"Bibb", @"Bleckley", @"Brantley", @"Brooks", @"Bryan", @"Bulloch", @"Burke", @"Butts", @"Calhoun", @"Camden", @"Candler", @"Carroll", @"Catoosa", @"Charlton", @"Chatham", @"Chattahoochee", @"Chattooga", @"Cherokee", @"Clarke", @"Clay", @"Clayton", @"Clinch", @"Cobb", @"Coffee", @"Colquitt", @"Columbia", @"Cook", @"Coweta", @"Crawford", @"Crisp", @"Dade", @"Dawson", @"Decatur", @"DeKalb", @"Dodge", @"Dooly", @"Dougherty", @"Douglas", @"Early", @"Echols", @"Effingham", @"Elbert", @"Emanuel", @"Evans", @"Fannin", @"Fayette", @"Floyd", @"Forsyth", @"Franklin", @"Fulton", @"Gilmer", @"Glascock", @"Glynn", @"Gordon", @"Grady", @"Greene", @"Gwinnett", @"Habersham", @"Hall", @"Hancock", @"Haralson", @"Harris", @"Hart", @"Heard", @"Henry", @"Houston", @"Irwin", @"Jackson", @"Jasper", @"Jeff Davis", @"Jefferson", @"Jenkins", @"Johnson", @"Jones", @"Lamar", @"Lanier", @"Laurens", @"Lee", @"Liberty", @"Lincoln", @"Long", @"Lowndes", @"Lumpkin", @"Macon", @"Madison", @"Marion", @"McDuffie", @"McIntosh", @"Meriwether", @"Miller", @"Mitchell", @"Monroe", @"Montgomery", @"Morgan", @"Murray", @"Muscogee", @"Newton", @"Oconee", @"Oglethorpe", @"Paulding", @"Peach", @"Pickens", @"Pierce", @"Pike", @"Polk", @"Pulaski", @"Putnam", @"Quitman", @"Rabun", @"Randolph", @"Richmond", @"Rockdale", @"Schley", @"Screven", @"Seminole", @"Spalding", @"Stephens", @"Stewart", @"Sumter", @"Talbot", @"Taliaferro", @"Tattnall", @"Taylor Webster", @"Telfair", @"Terrell", @"Thomas", @"Tift", @"Toombs", @"Towns", @"Treutlen", @"Troup", @"Turner", @"Twiggs", @"Union", @"Upson", @"Walker", @"Walton", @"Ware", @"Warren", @"Washington", @"Wayne", @"Wheeler", @"White", @"Whitfield", @"Wilcox", @"Wilkes", @"Wilkinson", @"Worth", nil];
    
    _payments = [NSArray arrayWithObjects:@"SEA", @"Paid", nil];

    _types = [NSArray arrayWithObjects:@"Instructor Lead", @"Aqua Adventure", nil];

    _programs = [NSArray arrayWithObjects:@"Aqua Tales", @"Hide and Seek", @"Bite Sized Basics", @"Sea Life Safari", @"Weird and Wild", @"Snack Attack", @"Undersea Investigators", @"Sharks In Depth", @"Aquarium 101", @"Animal Behavior", @"Discovery Lab - Genetics", @"Discovery Lab - Senses", @"Behind the Waterworks", @"Beyond the Classroom", nil];
        
    // anyway to do this in IB?
    buttonsCell.backgroundColor = [UIColor clearColor];
    buttonsCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    sigCell.backgroundColor = [UIColor clearColor];
    sigCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [getSignatureButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [getSignatureButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [viewScheduleButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [viewScheduleButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [visitorCounterButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [visitorCounterButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];

}

-(void) loadNewModel:(Visit*)visitModel{
    // Handle signature image
    if(visitModel.signatureImage != nil){
        [sigImage setImage:_visit.signatureImage];
        [sigCell setHidden:NO];
    }
    else{
        [sigImage setImage:nil];
        [sigCell setHidden:YES];
    }
        
    _visit = visitModel;

    self.title = _visit.school;
    time.text = [_visit formattedDate];
    schoolName.text = _visit.school;
    leadTeacher.text = _visit.leadTeacher;
    state.text = [@"Georgia" isEqualToString:_visit.state] ? [NSString stringWithFormat:@"%@ (%@ County)", _visit.state, _visit.county] : _visit.state;
    type.text = [@"Instructor Lead" isEqualToString:_visit.theType] ? [NSString stringWithFormat:@"%@ (%@ Program)",_visit.theType, _visit.program] : _visit.theType;
    payment.text = _visit.paymentType;
    curbNotes.text = _visit.curbNotes;
    studentCount.text = [_visit.actualStudentCount stringValue];
    chapCount.text = [_visit.actualChaperoneCount stringValue];
    extChapCount.text = [_visit.actualExtraChaperoneCount stringValue];
    studentProjected.text = [NSString stringWithFormat:@"Projected: %@", _visit.studentCount];
    chapProjected.text = [NSString stringWithFormat:@"Projected: %@", _visit.chaperoneCount];
    extChapProjected.text = [NSString stringWithFormat:@"Projected: %@", _visit.extraChaperoneCount];
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

}

-(void) configureView{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [sigCell setHidden:YES];
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
    buttonsCell = nil;
    getSignatureButton = nil;
    viewScheduleButton = nil;
    visitorCounterButton = nil;
    sigImage = nil;
    sigCell = nil;
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
    [sigImage setImage:signatureImage];
    [sigCell setHidden:NO];
    
    _visit.signatureImage = signatureImage;
    [_visit flagAsDirty:YES];
    
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
    NSNumber *asc = [counterData objectForKey:@"studentCount"];
    NSNumber *acc = [counterData objectForKey:@"chaperoneCount"];
    NSNumber *ecc = [counterData objectForKey:@"extraChaperoneCount"];
    
    if(![asc isEqualToNumber:_visit.actualStudentCount]){
        _visit.actualStudentCount = asc;
        [_visit flagAsDirty:YES];
    }
    if(![acc isEqualToNumber:_visit.actualChaperoneCount]){
        _visit.actualChaperoneCount = acc;
        [_visit flagAsDirty:YES];
    }
    if(![ecc isEqualToNumber:_visit.actualExtraChaperoneCount]){
        _visit.actualExtraChaperoneCount = ecc;
        [_visit flagAsDirty:YES];
    }
    
    [self loadNewModel:_visit]; // resyncs the fields
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [_visit flagAsNeedingDBUpdate];
        RKManagedObjectStore *store = [RKObjectManager sharedManager].objectStore;
        NSError *err = nil;
        [store save:&err];
        
        if(err != nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error saving to the local database. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [self.view endEditing:TRUE];
            [alert show];
        
            NSLog(@"Error saving to store! %@", [err description]);
        }
        else {
            NSLog(@"Successfully saved to store!");
            if(self.delegate != nil){
                [self.delegate didSave];
            }
        }
        
        [_visit flagAsDirty:NO];
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
    else if(indexPath.section == 1){
        if(indexPath.row == 0) [studentCount becomeFirstResponder];
        else if(indexPath.row == 1) [chapCount becomeFirstResponder];
        else if(indexPath.row == 2) [extChapCount becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    // TODO: deal with time
    if(textField == schoolName && ![textField.text isEqualToString:_visit.school]){
        _visit.school = textField.text;
        [_visit flagAsDirty:YES];
    }
    else if(textField == leadTeacher && ![textField.text isEqualToString:_visit.leadTeacher]){
        _visit.leadTeacher = textField.text;
        [_visit flagAsDirty:YES];
    }
    else if(textField == curbNotes && ![textField.text isEqualToString:_visit.curbNotes]){
        _visit.curbNotes = textField.text;
        [_visit flagAsDirty:YES];
    }
    else if(textField == studentCount && (_visit.actualStudentCount == nil || ![[numberFormatter numberFromString:textField.text] isEqualToNumber:_visit.actualStudentCount])){
        _visit.actualStudentCount = [numberFormatter numberFromString:textField.text];
        [_visit flagAsDirty:YES];
    }
    else if(textField == chapCount && (_visit.actualChaperoneCount == nil || ![[numberFormatter numberFromString:textField.text] isEqualToNumber:_visit.actualChaperoneCount])){
        _visit.actualChaperoneCount = [numberFormatter numberFromString:textField.text];
        [_visit flagAsDirty:YES];
    }
    else if(textField == extChapCount && (_visit.actualExtraChaperoneCount == nil || ![[numberFormatter numberFromString:textField.text] isEqualToNumber:_visit.actualExtraChaperoneCount])){
        _visit.actualExtraChaperoneCount = [numberFormatter numberFromString:textField.text];
        [_visit flagAsDirty:YES];
    }
}

#pragma mark -
#pragma mark Segue Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"modalVisitorCounterSegue"]){
        VisitorCounterViewController *vc = (VisitorCounterViewController*) segue.destinationViewController;
        vc.delegate = self;
        [vc setCountsForStudents:[_visit.actualStudentCount intValue] andChaps:[_visit.actualChaperoneCount intValue] andExtraChaps:[_visit.actualExtraChaperoneCount intValue]];
        [vc setProvidedCountsForStudents:_visit.studentCount andChaps:_visit.chaperoneCount andExtraChaps:_visit.extraChaperoneCount];
    }
    else if([segue.identifier isEqualToString:@"scheduleSegue"]){
        ScheduleViewController *vc = (ScheduleViewController*) segue.destinationViewController;
        vc.delegate = self;
        vc.visit = _visit;
        [vc.navigationController.navigationBar setHidden:NO];
    }
}

@end
