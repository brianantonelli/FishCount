//
//  VisitFormDataSource.m
//  FishCount
//
//  Created by Antonelli Brian on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VisitFormDataSource.h"
#import <IBAForms/IBAForms.h>
#import "Visit.h"
#import "StringToNumberTransformer.h"

@implementation VisitFormDataSource
@synthesize states, counties, programs, delegate;


- (id)initWithModel:(id)aModel 
{
	if (self = [super initWithModel:aModel]) {
        self.states = [NSArray arrayWithObjects:@"Canda", @"Mexico", @"International", @"", @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", nil];
        
        self.counties = [NSArray arrayWithObjects: @"APS", @"Appling", @"Atkinson", @"Bacon", @"Baker", @"Baldwin", @"Banks", @"Barrow", @"Bartow", @"Ben Hill", @"Berrien", @"Bibb", @"Bleckley", @"Brantley", @"Brooks", @"Bryan", @"Bulloch", @"Burke", @"Butts", @"Calhoun", @"Camden", @"Candler", @"Carroll", @"Catoosa", @"Charlton", @"Chatham", @"Chattahoochee", @"Chattooga", @"Cherokee", @"Clarke", @"Clay", @"Clayton", @"Clinch", @"Cobb", @"Coffee", @"Colquitt", @"Columbia", @"Cook", @"Coweta", @"Crawford", @"Crisp", @"Dade", @"Dawson", @"Decatur", @"DeKalb", @"Dodge", @"Dooly", @"Dougherty", @"Douglas", @"Early", @"Echols", @"Effingham", @"Elbert", @"Emanuel", @"Evans", @"Fannin", @"Fayette", @"Floyd", @"Forsyth", @"Franklin", @"Fulton", @"Gilmer", @"Glascock", @"Glynn", @"Gordon", @"Grady", @"Greene", @"Gwinnett", @"Habersham", @"Hall", @"Hancock", @"Haralson", @"Harris", @"Hart", @"Heard", @"Henry", @"Houston", @"Irwin", @"Jackson", @"Jasper", @"Jeff Davis", @"Jefferson", @"Jenkins", @"Johnson", @"Jones", @"Lamar", @"Lanier", @"Laurens", @"Lee", @"Liberty", @"Lincoln", @"Long", @"Lowndes", @"Lumpkin", @"Macon", @"Madison", @"Marion", @"McDuffie", @"McIntosh", @"Meriwether", @"Miller", @"Mitchell", @"Monroe", @"Montgomery", @"Morgan", @"Murray", @"Muscogee", @"Newton", @"Oconee", @"Oglethorpe", @"Paulding", @"Peach", @"Pickens", @"Pierce", @"Pike", @"Polk", @"Pulaski", @"Putnam", @"Quitman", @"Rabun", @"Randolph", @"Richmond", @"Rockdale", @"Schley", @"Screven", @"Seminole", @"Spalding", @"Stephens", @"Stewart", @"Sumter", @"Talbot", @"Taliaferro", @"Tattnall", @"Taylor Webster", @"Telfair", @"Terrell", @"Thomas", @"Tift", @"Toombs", @"Towns", @"Treutlen", @"Troup", @"Turner", @"Twiggs", @"Union", @"Upson", @"Walker", @"Walton", @"Ware", @"Warren", @"Washington", @"Wayne", @"Wheeler", @"White", @"Whitfield", @"Wilcox", @"Wilkes", @"Wilkinson", @"Worth", nil];

        self.programs = [NSArray arrayWithObjects:@"Aqua Tales", @"Hide and Seek", @"Bite Sized Basics", @"Sea Life Safari", @"Weird and Wild", @"Snack Attack", @"Undersea Investigators", @"Sharks In Depth", @"Aquarium 101", @"Animal Behavior", @"Discovery Lab - Genetics", @"Discovery Lab - Senses", @"Behind the Waterworks", @"Beyond the Classroom", nil];

        Visit *visit = (Visit*) self.model;

		IBAFormSection *basicFieldSection = [self addSectionWithHeaderTitle:@"School Information" footerTitle:nil];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateFormatter setDateFormat:@"EEE MMM d yyyy h:mm a"];
        [basicFieldSection addFormField:[[IBADateFormField alloc] initWithKeyPath:@"time"
                                                                             title:@"Time"
                                                                      defaultValue:[NSDate date]
                                                                              type:IBADateFormFieldTypeDateTime
                                                                     dateFormatter:dateFormatter]];
        [basicFieldSection addFormField:[[IBATextFormField alloc] initWithKeyPath:@"school" title:@"School Name"]];
        [basicFieldSection addFormField:[[IBATextFormField alloc] initWithKeyPath:@"leadTeacher" title:@"Lead Teacher"]];

		NSArray *pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:self.states];
        IBAPickListFormOptionsStringTransformer *transformer = [[IBAPickListFormOptionsStringTransformer alloc] initWithPickListOptions:pickListOptions];
		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"stateControl"
                                                                                 title:@"State"
                                                                      valueTransformer:transformer
                                                                         selectionMode:IBAPickListSelectionModeSingle
                                                                               options:pickListOptions]];
		
        if([@"Georgia" isEqualToString:visit.state]){
            [self addCounty];
        }
        
        NSArray *pickListOptions3 = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:@"SEA", @"Paid", nil]];
        IBAPickListFormOptionsStringTransformer *transformer3 = [[IBAPickListFormOptionsStringTransformer alloc] initWithPickListOptions:pickListOptions3];
		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"paymentTypeControl"
                                                                                 title:@"Payment"
                                                                      valueTransformer:transformer3
                                                                         selectionMode:IBAPickListSelectionModeSingle
                                                                               options:pickListOptions3]];

        NSArray *pickListOptions4 = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:@"Instructor Lead", @"Aqua Adventure", nil]];
        IBAPickListFormOptionsStringTransformer *transformer4 = [[IBAPickListFormOptionsStringTransformer alloc] initWithPickListOptions:pickListOptions4];
		[basicFieldSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"theTypeControl"
                                                                                 title:@"Type"
                                                                      valueTransformer:transformer4
                                                                         selectionMode:IBAPickListSelectionModeSingle
                                                                               options:pickListOptions4]];
        
        [self addPrograms];
        
        [basicFieldSection addFormField:[[IBATextFormField alloc] initWithKeyPath:@"curbNotes" title:@"Curb Notes"]];

        /// -----
        
        IBAFormSection *countsSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
		IBATextFormField *numberField = [[IBATextFormField alloc] initWithKeyPath:@"actualStudentCount"
																			title:@"Student Count"
																 valueTransformer:[StringToNumberTransformer instance]];
		[countsSection addFormField:numberField];
		numberField.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;

		IBATextFormField *numberField2 = [[IBATextFormField alloc] initWithKeyPath:@"actualChaperoneCount"
																			title:@"Chaperon Count"
																 valueTransformer:[StringToNumberTransformer instance]];
		[countsSection addFormField:numberField2];
		numberField2.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;

		IBATextFormField *numberField3 = [[IBATextFormField alloc] initWithKeyPath:@"actualExtraChaperoneCount"
																			title:@"Extra Champ."
																 valueTransformer:[StringToNumberTransformer instance]];
		[countsSection addFormField:numberField3];
		numberField3.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        
}
    
    return self;
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];

    Visit *visit = (Visit*) self.model;
    if([@"stateControl" isEqualToString:keyPath]){
        if([@"Georgia" isEqualToString:[visit.stateControl anyObject]]){
            [self addCounty];
        }
        else{
            [self removeCellInSection:0 withTitle:@"County"];
        }
    }
    
}

-(void) addCounty{
    IBAFormSection *schoolSection = [self.sections objectAtIndex:0];
    
    NSArray *options = [IBAPickListFormOption pickListOptionsForStrings:self.counties];
    IBAPickListFormOptionsStringTransformer *tx = [[IBAPickListFormOptionsStringTransformer alloc] initWithPickListOptions:options];
    [schoolSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"countyControl"
                                                                         title:@"County"
                                                              valueTransformer:tx
                                                                 selectionMode:IBAPickListSelectionModeSingle
                                                                       options:options] atIndex:4];
    
    [self.delegate tableCellsHaveChanged];
}

-(void) addPrograms{
    IBAFormSection *schoolSection = [self.sections objectAtIndex:0];
    
    NSArray *options = [IBAPickListFormOption pickListOptionsForStrings:self.programs];
    IBAPickListFormOptionsStringTransformer *tx = [[IBAPickListFormOptionsStringTransformer alloc] initWithPickListOptions:options];
    [schoolSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"programControl"
                                                                             title:@"Program"
                                                                  valueTransformer:tx
                                                                     selectionMode:IBAPickListSelectionModeSingle
                                                                           options:options]];
    
    [self.delegate tableCellsHaveChanged];
}

-(void) removeCellInSection:(NSUInteger)sectionIndex withTitle:(NSString*)title{
    IBAFormSection *section = [self.sections objectAtIndex:sectionIndex];
    id obj = nil;
    for (IBAFormField *field in section.formFields) {
        if([title isEqualToString:field.title]){
            obj = field;
        }
    }
    
    if(obj != nil){
        [section.formFields removeObject:obj];
    }
    
    [self.delegate tableCellsHaveChanged];
}

@end
