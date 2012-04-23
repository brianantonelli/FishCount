//
//  AppDelegate.m
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "Visit.h"

@implementation AppDelegate

@synthesize window = _window;

-(void) configureRestKit{
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);

	RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://192.168.0.147:3000"];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Configure object mappings
    RKObjectMapping* visitMapping = [RKObjectMapping mappingForClass:[Visit class]];
    //visitMapping.primaryKeyAttribute = @"identifier";
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
//     @"paymenttype", @"paymentType", nil];
    
    [objectManager.mappingProvider setObjectMapping:visitMapping forResourcePathPattern:@"/visits.json"]; // TODO: date parameter
    
    // Setup inverse serialization mapping for posting
    [objectManager.mappingProvider setSerializationMapping:[visitMapping inverseMapping] forClass:[Visit class]];
    
    // Setup routing
    [objectManager.router routeClass:[Visit class] toResourcePath:@"/visits/:identifier.json"];
    [objectManager.router routeClass:[Visit class] toResourcePath:@"/visits.json" forMethod:RKRequestMethodGET];
    [objectManager.router routeClass:[Visit class] toResourcePath:@"/visits.json" forMethod:RKRequestMethodPOST];
    [objectManager.router routeClass:[Visit class] toResourcePath:@"/visits/:identifier.json" forMethod:RKRequestMethodPUT];
    
    // MySQL date format
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd HH:mm:ss" inTimeZone:nil];

    /**
     TODO: parameter values are being sent flat RoR expects them to be in an object under the key "visit" ie: Parameters: {"visit" => {school: "brian"}}
    Visit *test = [Visit new];
    test.school = @"west!";
    [[RKObjectManager sharedManager] postObject:test delegate:self];
     */
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    NSLog(@"error!!! %@", [error description]);
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
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
