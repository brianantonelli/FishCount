//
//  ScheduleViewController.h
//  FishCount
//
//  Created by Antonelli Brian on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
