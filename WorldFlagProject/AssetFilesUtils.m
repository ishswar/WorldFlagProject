//
//  AssetFilesUtils.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/16/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "AssetFilesUtils.h"

#define FILE_EXT1 @"png"
#define FILE_EXT2 @"jpg"


@implementation AssetFilesUtils

// Class method to Read all the files ( names ) from bunlde Path - > apply some filters and retrun as NSArray
+(NSArray*)getAllassetFiles
{
    // Read all the path in bundle Path
    NSString *documentsDirectory = [[NSBundle mainBundle] bundlePath ];
    NSError * error;
    NSArray * directoryContents =  [[NSFileManager defaultManager]
                          contentsOfDirectoryAtPath:documentsDirectory error:&error];
    // We only need file with this extensions
    NSArray *extensions = [NSArray arrayWithObjects:FILE_EXT1, nil];
    
    //Apply extension predicate
    directoryContents = [directoryContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]];
    
    //We don't need file starting with "icon_"
    NSPredicate *iconffiles = [NSPredicate predicateWithFormat:@"SELF contains 'icon_'"];
    NSPredicate *noIconfiles = [NSCompoundPredicate notPredicateWithSubpredicate:iconffiles];
    // Remove files from directory that starts with "icon_"
    directoryContents = [directoryContents filteredArrayUsingPredicate:noIconfiles];
    
    // We don't  need file that has word "LaunchImage" in it ..
    NSPredicate *launchImage = [NSPredicate predicateWithFormat:@"SELF contains 'LaunchImage'"];
    NSPredicate *nolaunchImage = [NSCompoundPredicate notPredicateWithSubpredicate:launchImage];
    directoryContents = [directoryContents filteredArrayUsingPredicate:nolaunchImage];

    
    
    return directoryContents;
    
}

// Get a NSArray containing all the english alphabets
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

//File names have "_" in it - to make that file name clean we remove it ( for display purpose )
+(NSString*)formatCountryName:(NSString*)input
{
    
    return [[[input lastPathComponent] stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
}
//If name has been while space then replace it with "_" + add extension to it so it becomes file name ( for Reading file from disk purpose )
+(NSString*)CountryNametoFileName:(NSString*)input
{
    //Add "." to file extenssion 
    NSString *file_wt_ext = [NSString stringWithFormat:@".%@", FILE_EXT1];
    return [[input stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingString:file_wt_ext];
    
}





@end
