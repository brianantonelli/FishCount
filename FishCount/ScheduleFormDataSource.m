//
//  ScheduleFormDataSource.m
//  FishCount
//
//  Created by Antonelli Brian on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleFormDataSource.h"

@implementation ScheduleFormDataSource

- (id)initWithModel:(id)aModel 
{
	if (self = [super initWithModel:aModel]) {
        IBAFormSection *section = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        [section addFormField:[[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"school" title:@"School Name"] autorelease]];
        
        IBAFormSection *section1 = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        [section1 addFormField:[[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"grade" title:@"Grade"] autorelease]];
        [section1 addFormField:[[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"theatre" title:@"Theatre"] autorelease]];
        [section1 addFormField:[[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"lunch" title:@"Lunch"] autorelease]];
        [section1 addFormField:[[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"dolphin" title:@"Dolphin"] autorelease]];

        IBAFormSection *section2 = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        [section2 addFormField:[[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"bus" title:@"Bus"] autorelease]];
        [section2 addFormField:[[[IBAReadOnlyTextFormField alloc] initWithKeyPath:@"notes" title:@"Notes"] autorelease]];
}
    
    return self;
}

@end
