//
//  ImageHelper.m
//  FishCount
//
//  Created by Brian Antonelli on 7/15/12.
//
//

#import "ImageHelper.h"

@implementation ImageHelper

+(void) storeImage:(UIImage*)image withFileName:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: fileName];
    NSLog(@"saving image to %@", filePath);
    [UIImagePNGRepresentation(image) writeToFile: filePath atomically:YES];
}

+(UIImage*) retrieveImageWithFileName:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: fileName];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:filePath];

    return img;
}

@end
