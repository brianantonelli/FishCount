/**
 
 FishCount
 Copyright (C) 2012 Brian Antonelli
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 
 */

//  Created by Antonelli Brian on 4/17/12.

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
    [self.view endEditing:TRUE];
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
    saving = YES;
    BOOL needsSync = NO;
    for (Visit *aVisit in self.visits) {
        if([aVisit.updateDatabase boolValue]){
            needsSync = YES;

            [[RKObjectManager sharedManager] putObject:aVisit usingBlock:^(RKObjectLoader* loader){
                NSData *sigData = UIImagePNGRepresentation(aVisit.signatureImage);    
                RKObjectMapping* serializationMapping = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[Visit class]];
                NSError* error = nil;
                NSDictionary* dictionary = [[RKObjectSerializer serializerWithObject:aVisit mapping:serializationMapping] serializedObject:&error];
                RKParams* params = [RKParams paramsWithDictionary:dictionary];
                [params setData:sigData MIMEType:@"image/png" forParam:@"sigImage"];
                loader.params = params;
                loader.delegate = self;
            }];
        }
    }
    
    if(needsSync){
        [self loadObjectsFromWeb];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You haven't saved any records so there's nothing to sync." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [self.view endEditing:TRUE];
        [alert show];
    }
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if(!saving){
        self.visits = objects;
        [self.tableView reloadData];
    }
    else{
        NSLog(@"we be savin");
        saving = NO;
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[error localizedDescription] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[self.view endEditing:TRUE];
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
    self.detailViewController.delegate = self;
    
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
    NSLog(@"----cellForRowAtIndexPath");
    if([visit.updateDatabase boolValue]){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
        cell.accessoryView = imgView;
    }
    else{
        cell.accessoryView = nil;
    }
    
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
        [self.view endEditing:TRUE];
        [alert show];
    }
    else{
        _lastSelectedIndex = indexPath;
        [self.detailViewController loadNewModel:nextVisit];
    }
}

#pragma mark -
#pragma mark DetailViewControllerDelegate

-(void) didSave{
    NSLog(@"sizaved");
    [self.tableView reloadData];
}

@end
