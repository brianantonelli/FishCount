//
//  MasterViewController.m
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Visit.h"
#import "VisitFormDataSource.h"
#import <RestKit/NSString+RKAdditions.h>

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize visits;

-(void) loadObjectsFromDataStore{
    
}

-(void) loadObjectsFromWeb{
    /** TODO: turn on when sufficient data exists!
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"MM/dd/yy"];
   
    NSDictionary *queryParams = [NSDictionary dictionaryWithObject:[dateFormat stringFromDate:today] forKey:@"date"];
    NSString *resourcePath = [@"/visits.json" stringByAppendingQueryParameters:queryParams];
    */
    
    NSString *resourcePath = @"/visits.json";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

#pragma mark RKObjectLoaderDelegate methods
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    self.visits = objects;
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[error localizedDescription] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)dealloc
{
    [_detailViewController release];
    [visits release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

//    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
//    self.navigationItem.rightBarButtonItem = addButton;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self loadObjectsFromWeb];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)insertNewObject:(id)sender
{
    if (!visits) {
        self.visits = [[NSArray alloc] init];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return visits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    Visit *visit = [visits objectAtIndex:indexPath.row];
    cell.textLabel.text = [visit school];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Visit *visit = [visits objectAtIndex:indexPath.row];

    if(self.detailViewController.visit == visit) return;

    // Move value into multiselect controls for new model
    if(visit.state != nil) visit.stateControl = [NSSet setWithObject:visit.state];
    if(visit.county != nil) visit.countyControl = [NSSet setWithObject:visit.county];
    if(visit.program != nil) visit.programControl = [NSSet setWithObject:visit.program];
    if(visit.paymentType != nil) visit.paymentTypeControl = [NSSet setWithObject:visit.paymentType];
    if(visit.theType != nil) visit.theTypeControl = [NSSet setWithObject:visit.theType];
    
    // Copy out the value from the multiselect controls to the string value for old model
    Visit *old = self.detailViewController.formDataSource.model;
    old.state = [NSString stringWithFormat:@"%@", [old.stateControl anyObject]];
    old.county = [NSString stringWithFormat:@"%@", [old.countyControl anyObject]];
    old.program = [NSString stringWithFormat:@"%@", [old.programControl anyObject]];
    old.paymentType = [NSString stringWithFormat:@"%@", [old.paymentTypeControl anyObject]];
    old.theType = [NSString stringWithFormat:@"%@", [old.theTypeControl anyObject]];

    
    [self.detailViewController loadNewModel:visit];
}

@end
