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

@property(nonatomic, retain) NSNumber *identifier;
@property(nonatomic, retain) NSNumber *order;
@property(nonatomic, retain) NSString *school;
@property(nonatomic, retain) NSString *info;
@property(nonatomic, retain) NSString *staff;
@property(nonatomic, retain) NSDate *time;
@property(nonatomic, retain) NSString *grade;
@property(nonatomic, retain) NSNumber *studentCount;
@property(nonatomic, retain) NSNumber *chaperoneCount;
@property(nonatomic, retain) NSNumber *extraChaperoneCount;
@property(nonatomic, retain) NSString *bus;
@property(nonatomic, retain) NSString *theatre;
@property(nonatomic, retain) NSString *lunch;
@property(nonatomic, retain) NSString *dolphin;
@property(nonatomic, retain) NSString *notes;
@property(nonatomic, retain) NSString *curbNotes;
@property(nonatomic, retain) NSString *county;
@property(nonatomic, retain) NSNumber *actualStudentCount;
@property(nonatomic, retain) NSNumber *actualChaperoneCount;
@property(nonatomic, retain) NSNumber *actualExtraChaperoneCount;
@property(nonatomic, retain) NSString *leadTeacher;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSString *paymentType;
@property(nonatomic, retain) NSString *program;
@property(nonatomic, retain) NSString *theType;

// control mappings
@property(nonatomic, retain) NSSet *stateControl;
@property(nonatomic, retain) NSSet *countyControl;
@property(nonatomic, retain) NSSet *paymentTypeControl;
@property(nonatomic, retain) NSSet *programControl;
@property(nonatomic, retain) NSSet *theTypeControl;
@property(nonatomic, retain) UIImage *signatureImage;

@end
