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

@interface DetailViewController : IBAFormViewController <UISplitViewControllerDelegate, ModalViewControllerDelegate, JBSignatureControllerDelegate, VisitFormDataSourceDelegate, VisitorCounterViewControllerDelegate>{
    UITableViewStyle tableViewStyle;
    Visit *visit;
    UIImageView *sigImage;    
    UIButton *getSignatureButton;
    UIButton *viewScheduleButton;
    UIButton *visitorCounterButton;
}

-(void) didClickScheduleButton:(id) sender;
-(void) didClickSignatureButton:(id) sender;
-(void) didClickVisitorCounterButton:(id) sender;
-(void) loadNewModel:(Visit*)visit;

@property(nonatomic, assign) UITableViewStyle tableViewStyle;
@property(nonatomic, retain) Visit *visit;
@property(nonatomic, retain) UIImageView *sigImage;
@property(nonatomic, retain) UIButton *getSignatureButton;
@property(nonatomic, retain) UIButton *viewScheduleButton;
@property(nonatomic, retain) UIButton *visitorCounterButton;

@end
