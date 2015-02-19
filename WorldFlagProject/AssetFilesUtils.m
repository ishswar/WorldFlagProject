//
//  AssetFilesUtils.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/16/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "AssetFilesUtils.h"

@implementation AssetFilesUtils


+(NSArray*)getAllassetFiles
{
    
    NSString *documentsDirectory = [[NSBundle mainBundle] bundlePath ];
    NSError * error;
    NSArray * directoryContents =  [[NSFileManager defaultManager]
                          contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    NSArray *extensions = [NSArray arrayWithObjects:@"png", nil];
    
    directoryContents = [directoryContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]];
                                  
    NSPredicate *iconffiles = [NSPredicate predicateWithFormat:@"SELF contains 'icon_'"];
    NSPredicate *noIconfiles = [NSCompoundPredicate notPredicateWithSubpredicate:iconffiles];
    directoryContents = [directoryContents filteredArrayUsingPredicate:noIconfiles];
    
    NSPredicate *launchImage = [NSPredicate predicateWithFormat:@"SELF contains 'LaunchImage'"];
    NSPredicate *nolaunchImage = [NSCompoundPredicate notPredicateWithSubpredicate:launchImage];
    directoryContents = [directoryContents filteredArrayUsingPredicate:nolaunchImage];

    
    
    return directoryContents;
    
}

+(NSArray*)getAlphabetArray
{
    NSMutableArray* allAlphabest = [[NSMutableArray alloc] init];
    for (char A = 'A'; A <= 'Z'; A++)
    {
        NSString *alphabest = [NSString stringWithFormat:@"%c", A];
        [allAlphabest  addObject:alphabest];
    }
    
    return [allAlphabest mutableCopy];
}

+(NSString*)formatCountryName:(NSString*)input
{
    
    return [[[input lastPathComponent] stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
}
+(NSString*)CountryNametoFileName:(NSString*)input
{
    return [[input stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingString:@".png"];
    //return [[[input lastPathComponent] stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
}



@end
