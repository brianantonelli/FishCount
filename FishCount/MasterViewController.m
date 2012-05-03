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
    [self.visits release];
    
    NSFetchRequest* request = [Visit fetchRequest];
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    self.visits = [Visit objectsWithFetchRequest:request];
}

-(void) loadObjectsFromWebPrompt{
    if([self.visits count] == 0){
        [self loadObjectsFromWeb];
        return;
    }
    
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Load New Data"];
	[alert setMessage:@"Do you want to load the latest data from the server? All existing data will be deleted. This cannot be undone!"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"No"];
	[alert addButtonWithTitle:@"Yes"];
	[alert show];
	[alert release];
}

-(void) loadObjectsFromWeb{
    // Clean out the store
    RKManagedObjectStore *store = [RKObjectManager sharedManager].objectStore;
    [store deletePersistantStore];
    
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

-(void) syncObjectsToWeb{
    NSLog(@"TODO: syncItemsToWeb");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TODO" message:@"-(void) syncObjectsToWeb{" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
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
	NSLog(@"objectLoader error: %@", error);
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [self loadObjectsFromWeb];
    }
}

#pragma mark -
#pragma mark View related

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *loadFromWebButton = [[[UIBarButtonItem alloc] initWithTitle:@"Load"
																	style:UIBarButtonItemStyleDone 
																   target:self 
																   action:@selector(loadObjectsFromWebPrompt)] autorelease];
    self.navigationItem.leftBarButtonItem = loadFromWebButton;
        
    UIBarButtonItem *syncToWebButton = [[[UIBarButtonItem alloc] initWithTitle:@"Sync"
                                                                           style:UIBarButtonItemStyleDone 
                                                                          target:self 
                                                                          action:@selector(syncObjectsToWeb)] autorelease];
    self.navigationItem.rightBarButtonItem = syncToWebButton;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self loadObjectsFromDataStore];
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

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
    [_detailViewController release];
    [visits release];
    [super dealloc];
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
    if(old != nil){
        old.state = [NSString stringWithFormat:@"%@", [old.stateControl anyObject]];
        old.county = [NSString stringWithFormat:@"%@", [old.countyControl anyObject]];
        old.program = [NSString stringWithFormat:@"%@", [old.programControl anyObject]];
        old.paymentType = [NSString stringWithFormat:@"%@", [old.paymentTypeControl anyObject]];
        old.theType = [NSString stringWithFormat:@"%@", [old.theTypeControl anyObject]];
        
        // Save to core data
        RKManagedObjectStore *store = [RKObjectManager sharedManager].objectStore;
        NSError *err = nil;
        [store save:&err];
        if(err != nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error saving to the local database." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            NSLog(@"Error saving to store! %@", [err description]);
        }
        else {
            NSLog(@"Successfully saved to store!");
        }
    }
    
    [self.detailViewController loadNewModel:visit];
}

@end
