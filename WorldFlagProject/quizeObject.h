//
//  quizeObject.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/20/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "quizeQuestion.h"

@interface quizeObject : NSObject

typedef enum {
    FlagtoText = 1,
    TexttoFlag = 2
} quizeType;


@property (strong,nonatomic) NSNumber* quizeNmuber;
@property (nonatomic) quizeType type;
@property (strong,nonatomic) NSString* quizediscription;
@property (strong,nonatomic) NSNumber* score;
@property (strong,nonatomic) NSDate* startedOn;
@property (strong,nonatomic) NSDate* stopedOn;
@property (nonatomic) NSTimeInterval quizeDuration;
@property (strong,nonatomic) NSMutableArray * arrayOfQuestions;
@property (nonatomic) BOOL hintused;
@property (nonatomic) BOOL highestscore;

@end
