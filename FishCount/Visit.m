//
//  Visit.m
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Visit.h"

@implementation Visit

@synthesize identifier, order, school, info, staff, time, grade, studentCount, chaperoneCount, extraChaperoneCount, bus, theatre, lunch, dolphin, notes, curbNotes, county, actualStudentCount, actualChaperoneCount, actualExtraChaperoneCount, leadTeacher, state, paymentType, stateControl, countyControl, program, programControl, paymentTypeControl, theType, theTypeControl, signatureImage;

#pragma mark -
#pragma mark Custom setters

// TODO: review the retains below.. doesnt seem right
-(void) setState:(NSString *)_state{
    state = _state;
    stateControl = [[NSSet setWithObject:_state] retain];
}

-(void) setStateControl:(NSSet *)_stateControl{
    state = [NSString stringWithFormat:@"%@", [[_stateControl allObjects] objectAtIndex:0]];
    stateControl = [[NSSet setWithSet:_stateControl] retain];
}

-(void) setCounty:(NSString *)_county{
    county = _county;
    countyControl = [[NSSet setWithObject:_county] retain];
}

-(void) setCountyControl:(NSSet *)_countyControl{
    county = [NSString stringWithFormat:@"%@", [[_countyControl allObjects] objectAtIndex:0]];
    countyControl = [[NSSet setWithSet:_countyControl] retain];
}

-(void) setPaymentType:(NSString *)_paymentType{
    paymentType = _paymentType;
    paymentTypeControl = [[NSSet setWithObject:_paymentType] retain];
}

-(void) setPaymentTypeControl:(NSSet *)_paymentTypeControl{
    paymentType = [NSString stringWithFormat:@"%@", [[_paymentTypeControl allObjects] objectAtIndex:0]];
    paymentTypeControl = [[NSSet setWithSet:_paymentTypeControl] retain];
}

-(void) setProgram:(NSString *)_program{
    program = _program;
    programControl = [[NSSet setWithObject:_program] retain];
}

-(void) setProgramControl:(NSSet *)_programControl{
    program = [NSString stringWithFormat:@"%@", [[_programControl allObjects] objectAtIndex:0]];
    programControl = [[NSSet setWithSet:_programControl] retain];
}

-(void) setTheType:(NSString *)_theType{
    theType = _theType;
    theTypeControl = [[NSSet setWithObject:_theType] retain];
}

-(void) setTheTypeControl:(NSSet *)_theTypeControl{
    theType = [NSString stringWithFormat:@"%@", [[_theTypeControl allObjects] objectAtIndex:0]];
    theTypeControl = [[NSSet setWithSet:_theTypeControl] retain];
}

#pragma mark -
#pragma mark Memory Management

-(void) dealloc{
    [identifier release];
    [order release];
    [school release];
    [info release];
    [staff release];
    [time release];
    [grade release];
    [studentCount release];
    [chaperoneCount release];
    [extraChaperoneCount release];
    [bus release];
    [theatre release];
    [lunch release];
    [dolphin release];
    [notes release];
    [curbNotes release];
    [county release];
    [actualStudentCount release];
    [actualChaperoneCount release];
    [actualExtraChaperoneCount release];
    [leadTeacher release];
    [state release];
    [paymentType release];
    [stateControl release];
    [countyControl release];
    [programControl release];
    [program release];
    [paymentTypeControl release];
    [theType release];
    [theTypeControl release];
    [signatureImage release];
    
    [super dealloc];
}

@end
