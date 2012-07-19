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

#import "Visit.h"
#import "ImageHelper.h"

@implementation Visit

@dynamic identifier, order, school, info, staff, time, grade, studentCount, chaperoneCount, extraChaperoneCount, bus, theatre, lunch, dolphin, notes, curbNotes, county, actualStudentCount, actualChaperoneCount, actualExtraChaperoneCount, leadTeacher, state, paymentType, program, theType, updateDatabase;

@synthesize signatureImage;

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    if((self = [super initWithEntity:entity insertIntoManagedObjectContext:context])){
        UIImage *sigImg = [ImageHelper retrieveImageWithFileName:[NSString stringWithFormat:@"school-%@.png", self.identifier]];
        if(sigImg != nil){
            self.signatureImage = sigImg;
        }
	}
	
	return self;
}

-(NSString*) formattedDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"EEE MMM d yyyy h:mm a"];
    
    return [dateFormatter stringFromDate:self.time];
}

-(void) flagAsNeedingDBUpdate{
    self.updateDatabase = [NSNumber numberWithBool:YES];
}

-(void) flagAsDirty:(BOOL)yup{
    dirty = yup;
}

-(BOOL) isDirty{
    return dirty;
}

-(void) saveSignatureLocally{
    [ImageHelper storeImage:signatureImage withFileName:[NSString stringWithFormat:@"school-%@.png", self.identifier]];
}

@end
