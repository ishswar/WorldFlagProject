//
//  CommonUtils.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/16/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

// Healper method - make a samll image out of Flag to put on map annotation
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
