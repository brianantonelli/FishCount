//
//  Visit.h
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>


@interface Visit : NSManagedObject{
    BOOL needsToBeSynced;
}

-(NSString*) formattedDate;

@property(nonatomic, strong) NSNumber *identifier;
@property(nonatomic, strong) NSNumber *order;
@property(nonatomic, strong) NSString *school;
@property(nonatomic, strong) NSString *info;
@property(nonatomic, strong) NSString *staff;
@property(nonatomic, strong) NSDate *time;
@property(nonatomic, strong) NSString *grade;
@property(nonatomic, strong) NSNumber *studentCount;
@property(nonatomic, strong) NSNumber *chaperoneCount;
@property(nonatomic, strong) NSNumber *extraChaperoneCount;
@property(nonatomic, strong) NSString *bus;
@property(nonatomic, strong) NSString *theatre;
@property(nonatomic, strong) NSString *lunch;
@property(nonatomic, strong) NSString *dolphin;
@property(nonatomic, strong) NSString *notes;
@property(nonatomic, strong) NSString *curbNotes;
@property(nonatomic, strong) NSString *county;
@property(nonatomic, strong) NSNumber *actualStudentCount;
@property(nonatomic, strong) NSNumber *actualChaperoneCount;
@property(nonatomic, strong) NSNumber *actualExtraChaperoneCount;
@property(nonatomic, strong) NSString *leadTeacher;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *paymentType;
@property(nonatomic, strong) NSString *program;
@property(nonatomic, strong) NSString *theType;

// control mappings
@property(nonatomic, strong) NSSet *stateControl;
@property(nonatomic, strong) NSSet *countyControl;
@property(nonatomic, strong) NSSet *paymentTypeControl;
@property(nonatomic, strong) NSSet *programControl;
@property(nonatomic, strong) NSSet *theTypeControl;
@property(nonatomic, strong) UIImage *signatureImage;

@end
