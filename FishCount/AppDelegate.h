//
//  AppDelegate.h
//  FishCount
//
//  Created by Antonelli Brian on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, RKObjectLoaderDelegate>

-(void) configureRestKit;

@property (strong, nonatomic) UIWindow *window;

@end
