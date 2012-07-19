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

//  Created by Antonelli Brian on 4/21/12.

#import <Foundation/Foundation.h>
#import <IBAForms/IBAFormViewController.h>

@protocol ModalViewControllerDelegate <NSObject>

@required

- (void)didDismissModalView;

@end

@class Visit;

@interface ScheduleViewController : UITableViewController{
    id<ModalViewControllerDelegate> __weak delegate;
    Visit *visit;
    IBOutlet UILabel *school;
    IBOutlet UILabel *grade;
    IBOutlet UILabel *theatre;
    IBOutlet UILabel *lunch;
    IBOutlet UILabel *dolphin;
    IBOutlet UILabel *bus;
    IBOutlet UILabel *notes;
}

-(IBAction)dismissView:(id)sender;

@property (nonatomic, weak) id<ModalViewControllerDelegate> delegate;
@property(nonatomic, strong) Visit *visit;

@end
