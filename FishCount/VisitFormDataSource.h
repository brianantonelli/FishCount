//
//  VisitFormDataSource.h
//  FishCount
//
//  Created by Antonelli Brian on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IBAForms/IBAForms.h>

@protocol VisitFormDataSourceDelegate <NSObject>

- (void)tableCellsHaveChanged;

@end

@interface VisitFormDataSource : IBAFormDataSource{
    NSArray *states;
    NSArray *counties;
    NSArray *programs;
    id<VisitFormDataSourceDelegate> delegate;
}

-(void) addCounty;
-(void) addPrograms;
-(void) removeCellInSection:(NSUInteger)sectionIndex withTitle:(NSString*)title;

@property(nonatomic, retain) NSArray *states;
@property(nonatomic, retain) NSArray *counties;
@property(nonatomic, retain) NSArray *programs;
@property (nonatomic, assign) id<VisitFormDataSourceDelegate> delegate;

@end
