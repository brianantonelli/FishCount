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
#import <RestKit/NSString+RKAdditions.h>

@implementation MasterViewController

@synthesize detailViewController = _detailViewController,
            lastSelectedIndex = _lastSelectedIndex;
@synthesize visits;

-(void) loadObjectsFromDataStore{
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
    
    alertType = kAlertTypeLoad;
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Load New Data"];
	[alert setMessage:@"Do you want to load the latest data from the server? All existing data will be deleted. This cannot be undone!"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"No"];
	[alert addButtonWithTitle:@"Yes"];
	[alert show];
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
    BOOL needsSync = NO;
    for (Visit *aVisit in self.visits) {
        if([aVisit.updateDatabase boolValue]){
            needsSync = YES;

            [[RKObjectManager sharedManager] putObject:aVisit delegate:self];
        }
    }
    
    if(!needsSync){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You haven't saved any records so there's nothing to sync." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    self.visits = objects;
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[error localizedDescription] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"objectLoader error: %@", error);
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertType == kAlertTypeLoad){
        if (buttonIndex == 1){
            [self loadObjectsFromWeb];
        }
    }
    else if(alertType == kAlertTypeSync){
    
    }
    else if(alertType == kAlertTypeDirty){
        if(buttonIndex == 1){
            Visit *nextVisit = [visits objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            [self.detailViewController loadNewModel:nextVisit];
            Visit *currentVisit = [visits objectAtIndex:_lastSelectedIndex.row];
            [[currentVisit managedObjectContext] refreshObject:currentVisit mergeChanges:NO];
            [currentVisit flagAsDirty:NO];
        }
        else{
            [self.tableView selectRowAtIndexPath:_lastSelectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

#pragma mark -
#pragma mark View related

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *loadFromWebButton = [[UIBarButtonItem alloc] initWithTitle:@"Load"
																	style:UIBarButtonItemStyleDone 
																   target:self 
																   action:@selector(loadObjectsFromWebPrompt)];
    self.navigationItem.leftBarButtonItem = loadFromWebButton;
        
    UIBarButtonItem *syncToWebButton = [[UIBarButtonItem alloc] initWithTitle:@"Sync"
                                                                           style:UIBarButtonItemStyleDone 
                                                                          target:self 
                                                                          action:@selector(syncObjectsToWeb)];
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
    cell.textLabel.text = visit.school;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Visit *currentVisit = self.detailViewController.visit;
    Visit *nextVisit = [visits objectAtIndex:indexPath.row];
    
    if(currentVisit == nextVisit) return;
    if([currentVisit isDirty]){
        alertType = kAlertTypeDirty;
    	UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Are you sure you want to load this record? The changes made to the current record will be lost."];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"No"];
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
    }
    else{
        _lastSelectedIndex = indexPath;
        [self.detailViewController loadNewModel:nextVisit];
    }
}

@end
