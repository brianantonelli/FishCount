//
//  MasterViewController.h
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <RKObjectLoaderDelegate>{
    NSArray *visits;
}

-(void) loadObjectsFromDataStore;

-(void) loadObjectsFromWeb;

@property (strong, nonatomic) DetailViewController *detailViewController;
@property(nonatomic, retain) NSArray *visits;

@end
