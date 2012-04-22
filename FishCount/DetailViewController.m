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

@synthesize tableViewStyle, visit, sigImage, getSignatureButton, viewScheduleButton;
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
    
    // Add signature image
    self.sigImage = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 740.0f, 300.f, 100.0f)];
    [self.sigImage setHidden:YES];
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
    self.title = _visit.school;
    self.visit = _visit;
    
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
    
    [self.tableView addSubview:self.sigImage];
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
#pragma mark Memory Management

- (void)dealloc
{
    [_masterPopoverController release];
    [visit release];
    [sigImage release];
    [getSignatureButton release];
    [viewScheduleButton release];
    
    [super dealloc];
}


@end
