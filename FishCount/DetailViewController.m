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

@synthesize tableViewStyle, visit, sigImage, getSignatureButton;
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

    UIView *view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:[view bounds] style:UITableViewStyleGrouped] autorelease];
	[tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:tableView];
	
	[view addSubview:tableView];
	[self setView:view];
        
    self.getSignatureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.getSignatureButton setTitle:@"getSignatureButton" forState:UIControlStateNormal];
	[self.getSignatureButton sizeToFit];
	[self.getSignatureButton setFrame:CGRectMake(10.0f, 
										   10.0f, 
										   self.getSignatureButton.frame.size.width, 
										   self.getSignatureButton.frame.size.height)];
	[self.getSignatureButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
}

-(void) configureView{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: add to subview that scrolls
    [self.view addSubview:self.getSignatureButton];
    [self.getSignatureButton addTarget:self action:@selector(didClickSignatureButton:) forControlEvents:UIControlEventTouchUpInside];
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
    
    // TODO: not visible in portrait mode!
    UIBarButtonItem *scheduleButton = [[[UIBarButtonItem alloc] initWithTitle:@"View Schedule" 
                                                                        style:UIBarButtonItemStylePlain 
                                                                       target:self
                                                                       action:@selector(didClickScheduleButton:)
                                        ] autorelease];
    [self.navigationItem setLeftBarButtonItem:scheduleButton animated:YES];
    
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
    
    [super dealloc];
}


@end
