//
//  DetailViewController.h
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IBAForms/IBAFormViewController.h>
#import "ScheduleViewController.h"
#import "Visit.h"
#import "JBSignatureController.h"
#import "VisitFormDataSource.h"
#import "VisitorCounterViewController.h"

@interface DetailViewController : IBAFormViewController <UISplitViewControllerDelegate, ModalViewControllerDelegate, JBSignatureControllerDelegate, VisitFormDataSourceDelegate, VisitorCounterViewControllerDelegate, UIAlertViewDelegate>{
    UITableViewStyle tableViewStyle;
    Visit *visit;
    UIImageView *sigImage;    
    UIButton *getSignatureButton;
    UIButton *viewScheduleButton;
    UIButton *visitorCounterButton;
    UILabel *providedStudentCountLabel;
    UILabel *providedChaperoneCountLabel;
    UILabel *providedExtraChaperoneCountLabel;
}

-(void) didClickScheduleButton:(id) sender;
-(void) didClickSignatureButton:(id) sender;
-(void) didClickVisitorCounterButton:(id) sender;
-(void) didClickSaveButton:(id) sender;
-(void) loadNewModel:(Visit*)visit;

@property(nonatomic, assign) UITableViewStyle tableViewStyle;
@property(nonatomic, strong) Visit *visit;
@property(nonatomic, strong) UIImageView *sigImage;
@property(nonatomic, strong) UIButton *getSignatureButton;
@property(nonatomic, strong) UIButton *viewScheduleButton;
@property(nonatomic, strong) UIButton *visitorCounterButton;
@property(nonatomic, strong) UILabel *providedStudentCountLabel;
@property(nonatomic, strong) UILabel *providedChaperoneCountLabel;
@property(nonatomic, strong) UILabel *providedExtraChaperoneCountLabel;


@end
