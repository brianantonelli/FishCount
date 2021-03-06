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

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "Visit.h"

@implementation AppDelegate

@synthesize window = _window;

-(void) configureRestKit{
//    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);

//	RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://localhost:3000"];
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://brians-macbook-air.local:3000"];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Initialize object store
#ifdef RESTKIT_GENERATE_SEED_DB
    NSString *seedDatabaseName = nil;
    NSString *databaseName = RKDefaultSeedDatabaseFileName;
#else
    NSString *seedDatabaseName = RKDefaultSeedDatabaseFileName;
    NSString *databaseName = @"FishCount.sqlite";
#endif
    
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName 
                                                             usingSeedDatabaseName:seedDatabaseName 
                                                                managedObjectModel:nil 
                                                                          delegate:self];

    // Configure object mappings
    RKManagedObjectMapping* visitMapping = [RKManagedObjectMapping mappingForClass:[Visit class]inManagedObjectStore:objectManager.objectStore];
    visitMapping.primaryKeyAttribute = @"identifier";
    [visitMapping mapKeyPathsToAttributes:@"id", @"identifier",
     @"order", @"order",
     @"school", @"school",
     @"info", @"info",
     @"staff", @"staff",
     @"time", @"time",
     @"grade", @"grade",
     @"student", @"studentCount",
     @"chaperon", @"chaperoneCount",
     @"extrapdchaperon", @"extraChaperoneCount",
     @"bus", @"bus",
     @"theater", @"theatre",
     @"lunch", @"lunch",
     @"dolphin", @"dolphin",
     @"notes", @"notes",
     @"curb_notes", @"curbNotes",
     @"county", @"county",
     @"actual_student", @"actualStudentCount",
     @"actual_chaperon", @"actualChaperoneCount",
     @"actual_extrapdchaperon", @"actualExtraChaperoneCount",
     @"teacher", @"leadTeacher",
     @"state", @"state", nil];
    
    [objectManager.mappingProvider setObjectMapping:visitMapping forResourcePathPattern:@"/visits.json"];
    
    // Setup inverse serialization mapping for posting
    [objectManager.mappingProvider setSerializationMapping:[visitMapping inverseMapping] forClass:[Visit class]];
    
    // Setup routing
    [objectManager.router routeClass:[Visit class] toResourcePath:@"/visits/:identifier"];
    [objectManager.router routeClass:[Visit class] toResourcePath:@"/visits.json" forMethod:RKRequestMethodGET];
    [objectManager.router routeClass:[Visit class] toResourcePath:@"/visits.json" forMethod:RKRequestMethodPOST];
    [objectManager.router routeClass:[Visit class] toResourcePath:@"/visits/:identifier" forMethod:RKRequestMethodPUT];

#ifdef RESTKIT_GENERATE_SEED_DB
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelInfo);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
    RKManagedObjectSeeder* seeder = [RKManagedObjectSeeder objectSeederWithObjectManager:objectManager];
    
    // Seed the database with instances of Status from a snapshot of the RestKit Twitter timeline
    [seeder seedObjectsFromFile:@"visits.json" withObjectMapping:visitMapping];
    
    // Finalize the seeding operation and output a helpful informational message
    [seeder finalizeSeedingAndExit];
#endif
    
    // MySQL date format
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd HH:mm:ss" inTimeZone:nil];
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    NSLog(@"error!!! %@", [error description]);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureRestKit];
    
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
