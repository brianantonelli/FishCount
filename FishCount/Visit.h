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

//  Created by Antonelli Brian on 4/17/12.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>


@interface Visit : NSManagedObject{
    BOOL dirty;
}

-(NSString*) formattedDate;
-(void) flagAsNeedingDBUpdate;
-(void) flagAsDirty:(BOOL)yup;
-(BOOL) isDirty;
-(void) saveSignatureLocally;

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
@property(nonatomic, strong) NSNumber *updateDatabase;
@property(nonatomic, strong) UIImage *signatureImage;

@end
