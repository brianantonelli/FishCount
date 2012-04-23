//
//  DetailViewController.m
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "ScheduleViewController.h"
#import "ScheduleFormDataSource.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize tableViewStyle, visit, sigImage, getSignatureButton, viewScheduleButton, visitorCounterButton, providedStudentCountLabel, providedChaperoneCountLabel, providedExtraChaperoneCountLabel;
@synthesize masterPopoverController = _masterPopoverController;

-(void) didClickScheduleButton:(id) sender{
    ScheduleFormDataSource *ds = [[[ScheduleFormDataSource alloc] initWithModel:visit] autorelease];
    ScheduleViewController *schedule = [[ScheduleViewController alloc] initWithNibName:nil bundle:nil formDataSource:ds];
    schedule.delegate = self;
    
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:schedule];
    ctrl.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:ctrl animated:YES];
    [ctrl release];
    [schedule release];
}

-(void) didClickSignatureButton:(id) sender{
    JBSignatureController *signatureController = [[JBSignatureController alloc] init];
	signatureController.delegate = self;
    
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:signatureController];
    ctrl.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:ctrl animated:YES];
    [ctrl release];
    [signatureController release];
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
    [ctrl release];
    [visitCounterController release];
}

- (void)loadView 
{
	[super loadView];
    
    self.title = @"Georgia Aquarium Educator Assistant";

    // Setup view
    UIView *view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    // Setup table
    UITableView *tableView = [[[UITableView alloc] initWithFrame:[view bounds] style:UITableViewStyleGrouped] autorelease];
	[tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:tableView];
	
	[view addSubview:tableView];
	[self setView:view];
    
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
    
    // Provided Counter Labels
    self.providedStudentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(540.0f, 428.0f, 100.0f, 42.0f)];
    self.providedStudentCountLabel.textAlignment = UITextAlignmentRight;
    self.providedStudentCountLabel.font = [UIFont systemFontOfSize:12.0f];
    self.providedStudentCountLabel.backgroundColor = [UIColor clearColor];
    [self.providedStudentCountLabel setHidden:YES];
    
    self.providedChaperoneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(540.0f, 470.0f, 100.0f, 42.0f)];
    self.providedChaperoneCountLabel.textAlignment = UITextAlignmentRight;
    self.providedChaperoneCountLabel.font = [UIFont systemFontOfSize:12.0f];
    self.providedChaperoneCountLabel.backgroundColor = [UIColor clearColor];
    [self.providedChaperoneCountLabel setHidden:YES];
    
    self.providedExtraChaperoneCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(540.0f, 515.0f, 100.0f, 42.0f)];
    self.providedExtraChaperoneCountLabel.textAlignment = UITextAlignmentRight;
    self.providedExtraChaperoneCountLabel.font = [UIFont systemFontOfSize:12.0f];
    self.providedExtraChaperoneCountLabel.backgroundColor = [UIColor clearColor];
    [self.providedExtraChaperoneCountLabel setHidden:YES];

}

-(void) loadNewModel:(Visit*)_visit{
    // Setup datasource
    VisitFormDataSource *vfds = [[[VisitFormDataSource alloc] initWithModel:_visit] autorelease];
    vfds.delegate = self;
    self.formDataSource = vfds;

    // Handle signature image
    if(_visit.signatureImage != nil){
        [self.sigImage setImage:_visit.signatureImage];
        [self.sigImage setHidden:NO];
    }
    else{
        [self.sigImage setImage:nil];
        [self.sigImage setHidden:YES];
    }
    
    // Misc
    [self.getSignatureButton setHidden:NO];
    [self.viewScheduleButton setHidden:NO];
    [self.visitorCounterButton setHidden:NO];
    
    // Provided Counter Labels
    // Height needs to be dynamic.. :(
//    [self.providedStudentCountLabel setHidden:NO];
//    [self.providedChaperoneCountLabel setHidden:NO];
//    [self.providedExtraChaperoneCountLabel setHidden:NO];
    
    self.title = _visit.school;
    self.visit = _visit;

    self.providedStudentCountLabel.text = [NSString stringWithFormat:@"Est. %d", [self.visit.studentCount intValue]];
    self.providedChaperoneCountLabel.text = [NSString stringWithFormat:@"Est. %d", [self.visit.chaperoneCount intValue]];
    self.providedExtraChaperoneCountLabel.text = [NSString stringWithFormat:@"Est. %d", [self.visit.extraChaperoneCount intValue]];

//    NSLog(@"table height is = %d", self.tableView.frame.size.height);
}

-(void) configureView{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView addSubview:self.getSignatureButton];
    [self.getSignatureButton addTarget:self action:@selector(didClickSignatureButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView addSubview:self.viewScheduleButton];
    [self.viewScheduleButton addTarget:self action:@selector(didClickScheduleButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView addSubview:self.visitorCounterButton];
    [self.visitorCounterButton addTarget:self action:@selector(didClickVisitorCounterButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView addSubview:self.sigImage];
    
    // Provided Counter Labels
    [self.tableView addSubview:self.providedStudentCountLabel];
    [self.tableView addSubview:self.providedChaperoneCountLabel];
    [self.tableView addSubview:self.providedExtraChaperoneCountLabel];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.sigImage setHidden:YES];
}

- (void)viewDidUnload
{
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
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save"
																	style:UIBarButtonItemStyleDone 
																   target:nil 
																   action:nil] autorelease];
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
#pragma mark VisitFormDataSourceDelegate

- (void)tableCellsHaveChanged{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark VisitorCounterViewControllerDelegate

- (void)didDismissVisitorModalViewWithCounterData:(NSDictionary *)counterData{
    Visit *model = (Visit*) self.formDataSource.model;
    model.actualStudentCount = [counterData objectForKey:@"studentCount"];
    model.actualChaperoneCount = [counterData objectForKey:@"chaperoneCount"];
    model.actualExtraChaperoneCount = [counterData objectForKey:@"extraChaperoneCount"];

    [self.tableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
    [_masterPopoverController release];
    [visit release];
    [sigImage release];
    [getSignatureButton release];
    [viewScheduleButton release];
    [visitorCounterButton release];
    [providedStudentCountLabel release];
    [providedChaperoneCountLabel release];
    [providedExtraChaperoneCountLabel release];
    
    [super dealloc];
}


@end
