//
//  CommonUtils.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/16/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtils : NSObject

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+(NSString*)formattedStringForDuration:(NSTimeInterval)duration;
+(void)setGameTimeInUserDef:(NSInteger)intimer;

@end
