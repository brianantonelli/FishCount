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

//  Created by Antonelli Brian on 4/22/12.

#import <UIKit/UIKit.h>

@protocol VisitorCounterViewControllerDelegate <NSObject>

@required

- (void)didDismissVisitorModalViewWithCounterData:(NSDictionary*)counterData;

@end

@interface VisitorCounterViewController : UIViewController{
    NSNumber *providedStudentCount;
    NSNumber *providedChaperoneCount;
    NSNumber *providedExtraChaperoneCount;
    
    int studentCount;
    int chaperoneCount;
    int extraChaperoneCount;
    
    IBOutlet UITextField *studentInput;
    IBOutlet UITextField *chapInput;
    IBOutlet UITextField *extraChapInput;
    IBOutlet UILabel *studentEst;
    IBOutlet UILabel *chapEst;
    IBOutlet UILabel *extChapEst;
    IBOutlet UIStepper *studentStepper;
    IBOutlet UIStepper *chapStepper;
    IBOutlet UIStepper *extraChapStepper;
    
    id<VisitorCounterViewControllerDelegate> __weak delegate;
}

-(IBAction) didClickConfirmButton:(id) sender;
-(IBAction) studentTextFieldChanged;
-(IBAction) chaperoneTextFieldChanged;
-(IBAction) extraChaperoneTextFieldChanged;
- (IBAction)studentStepperChanged:(id)sender forEvent:(UIEvent *)event;
- (IBAction)chapStepperChanged:(id)sender forEvent:(UIEvent *)event;
- (IBAction)extraChapStepperChanged:(id)sender forEvent:(UIEvent *)event;
-(void) setCountsForStudents:(int)studCount andChaps:(int)chapCount andExtraChaps:(int)extraChaps;
-(void) setProvidedCountsForStudents:(NSNumber*)studCount andChaps:(NSNumber*)chapCount andExtraChaps:(NSNumber*)extraChaps;

@property(nonatomic, weak) id<VisitorCounterViewControllerDelegate> delegate;


@end
