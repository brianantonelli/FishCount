//
//  ImageHelper.h
//  FishCount
//
//  Created by Brian Antonelli on 7/15/12.
//
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject

+(void) storeImage:(UIImage*)image withFileName:(NSString*)fileName;

+(UIImage*) retrieveImageWithFileName:(NSString*)fileName;

@end
