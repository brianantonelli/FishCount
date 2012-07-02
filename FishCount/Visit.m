//
//  Visit.m
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Visit.h"

@implementation Visit

@dynamic identifier, order, school, info, staff, time, grade, studentCount, chaperoneCount, extraChaperoneCount, bus, theatre, lunch, dolphin, notes, curbNotes, county, actualStudentCount, actualChaperoneCount, actualExtraChaperoneCount, leadTeacher, state, paymentType, program, theType;

@synthesize signatureImage; // TODO: should we serialize this and store image incase they crash the app or the ipad battery dies?

-(NSString*) formattedDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"EEE MMM d yyyy h:mm a"];
    
    return [dateFormatter stringFromDate:self.time];
}

-(void) flagAsDirty{
    needsToBeSynced = YES;
}

-(BOOL) isDirty{
    return needsToBeSynced;
}

@end
