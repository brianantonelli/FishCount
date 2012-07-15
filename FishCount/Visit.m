//
//  Visit.m
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
