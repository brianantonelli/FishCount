//
//  MasterViewController.h
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "DetailViewController.h"

@class Visit;

typedef enum {
    kAlertTypeLoad,
    kAlertTypeSync,
    kAlertTypeDirty
} AlertType;

@interface MasterViewController : UITableViewController <RKObjectLoaderDelegate, UIAlertViewDelegate,DetailViewControllerDelegate>{
    NSArray *visits;
    NSIndexPath *lastSelectedIndex;
    AlertType alertType;
    BOOL saving;
}

-(void) loadObjectsFromDataStore;
-(void) loadObjectsFromWebPrompt;
-(void) loadObjectsFromWeb;
-(void) syncObjectsToWeb;

@property (strong, nonatomic) DetailViewController *detailViewController;
@property(nonatomic, strong) NSArray *visits;
@property(nonatomic, strong) NSIndexPath *lastSelectedIndex;

@end
