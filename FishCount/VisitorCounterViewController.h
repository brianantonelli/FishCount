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
    
    UILabel *studentCountLabel;
    UILabel *chaperoneCountLabel;
    UILabel *extraChaperoneCountLabel;
    
    UITextField *studentCountTextField;
    UITextField *chaperoneCountTextField;
    UITextField *extraChaperoneCountTextField;

    UILabel *providedStudentCountLabel;
    UILabel *providedChaperoneCountLabel;
    UILabel *providedExtraChaperoneCountLabel;
    
    UIButton *addStudentButton;
    UIButton *addChaperoneButton;
    UIButton *addExtraChaperoneButton;
    
    UIButton *removeStudentButton;
    UIButton *removeChaperoneButton;
    UIButton *removeExtraChaperoneButton;
    
    id<VisitorCounterViewControllerDelegate> delegate;
}

-(void) setCountsForStudents:(int)studCount andChaps:(int)chapCount andExtraChaps:(int)extraChaps;
-(void) didClickAddStudentButton:(id) sender;
-(void) didClickRemoveStudentButton:(id) sender;
-(void) didClickAddChaperoneButton:(id) sender;
-(void) didClickRemoveChaperoneButton:(id) sender;
-(void) didClickAddExtraChaperoneButton:(id) sender;
-(void) didCLickRemoveExtraChaperoneButton:(id) sender;
-(void) didClickConfirmButton:(id) sender;
-(void) studentTextFieldChanged;
-(void) chaperoneTextFieldChanged;
-(void) extraChaperoneTextFieldChanged;

@property(nonatomic, assign) id<VisitorCounterViewControllerDelegate> delegate;
@property(nonatomic, retain) UILabel *studentCountLabel;
@property(nonatomic, retain) UILabel *chaperoneCountLabel;
@property(nonatomic, retain) UILabel *extraChaperoneCountLabel;
@property(nonatomic, retain) UILabel *providedStudentCountLabel;
@property(nonatomic, retain) UILabel *providedChaperoneCountLabel;
@property(nonatomic, retain) UITextField *studentCountTextField;
@property(nonatomic, retain) UITextField *chaperoneCountTextField;
@property(nonatomic, retain) UITextField *extraChaperoneCountTextField;
@property(nonatomic, retain) UILabel *providedExtraChaperoneCountLabel;
@property(nonatomic, retain) UIButton *addStudentButton;
@property(nonatomic, retain) UIButton *addChaperoneButton;
@property(nonatomic, retain) UIButton *addExtraChaperoneButton;
@property(nonatomic, retain) UIButton *removeStudentButton;
@property(nonatomic, retain) UIButton *removeChaperoneButton;
@property(nonatomic, retain) UIButton *removeExtraChaperoneButton;
@property(nonatomic, retain) NSNumber *providedStudentCount;
@property(nonatomic, retain) NSNumber *providedChaperoneCount;
@property(nonatomic, retain) NSNumber *providedExtraChaperoneCount;


@end
