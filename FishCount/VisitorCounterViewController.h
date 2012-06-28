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
    
    id<VisitorCounterViewControllerDelegate> __weak delegate;
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

@property(nonatomic, weak) id<VisitorCounterViewControllerDelegate> delegate;
@property(nonatomic, strong) UILabel *studentCountLabel;
@property(nonatomic, strong) UILabel *chaperoneCountLabel;
@property(nonatomic, strong) UILabel *extraChaperoneCountLabel;
@property(nonatomic, strong) UILabel *providedStudentCountLabel;
@property(nonatomic, strong) UILabel *providedChaperoneCountLabel;
@property(nonatomic, strong) UITextField *studentCountTextField;
@property(nonatomic, strong) UITextField *chaperoneCountTextField;
@property(nonatomic, strong) UITextField *extraChaperoneCountTextField;
@property(nonatomic, strong) UILabel *providedExtraChaperoneCountLabel;
@property(nonatomic, strong) UIButton *addStudentButton;
@property(nonatomic, strong) UIButton *addChaperoneButton;
@property(nonatomic, strong) UIButton *addExtraChaperoneButton;
@property(nonatomic, strong) UIButton *removeStudentButton;
@property(nonatomic, strong) UIButton *removeChaperoneButton;
@property(nonatomic, strong) UIButton *removeExtraChaperoneButton;
@property(nonatomic, strong) NSNumber *providedStudentCount;
@property(nonatomic, strong) NSNumber *providedChaperoneCount;
@property(nonatomic, strong) NSNumber *providedExtraChaperoneCount;


@end
