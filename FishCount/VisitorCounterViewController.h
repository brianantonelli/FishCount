//
//  VisitorCounterViewController.h
//  FishCount
//
//  Created by Antonelli Brian on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
