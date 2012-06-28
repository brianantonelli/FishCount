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

@interface ScheduleViewController : IBAFormViewController{
    UITableViewStyle tableViewStyle;
    id<ModalViewControllerDelegate> __weak delegate;
}

-(void)dismissView:(id)sender;

@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, weak) id<ModalViewControllerDelegate> delegate;

@end
