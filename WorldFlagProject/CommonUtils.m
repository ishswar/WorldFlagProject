//
//  CommonUtils.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/16/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "CommonUtils.h"
#import "CommonStuffHeader.h"

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

// healper method - take NSTime interval and return minutes and string representation of it
+(NSString*)formattedStringForDuration:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
}

+(void)setGameTimeInUserDef:(NSInteger)intimer
{
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    
    [userdef setInteger:intimer forKey:GAME_TIMER_NAME_FOR_NSUSERDEFAULT];
    [userdef synchronize];
    
    
}
@end
