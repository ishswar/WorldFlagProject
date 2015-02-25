//
//  AssetFilesUtils.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/16/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetFilesUtils : NSObject

+(NSArray*)getAllassetFiles;
+(NSArray*)getAlphabetArray;
+(NSString*)formatCountryName:(NSString*)input;
+(NSString*)CountryNametoFileName:(NSString*)input;


@end
