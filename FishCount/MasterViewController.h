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
