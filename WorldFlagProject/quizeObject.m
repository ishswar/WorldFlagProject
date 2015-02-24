//
//  quizeObject.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/20/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "quizeObject.h"

@implementation quizeObject


//@property (strong,nonatomic) NSNumber* quizeNmuber;
//@property (strong,nonatomic) NSString* type;
//@property (strong,nonatomic) NSString* quizediscription;
//@property (strong,nonatomic) NSNumber* score;
//@property (strong,nonatomic) NSDate* startedOn;
//@property (strong,nonatomic) NSDate* stopedOn;
//@property (nonatomic) NSTimeInterval quizeDuration;
//@property (strong,nonatomic) NSMutableArray * arrayOfQuestions;


- (NSString *)description {
    return [NSString stringWithFormat: @"Quize  : number=%@ type=%u quizedesc=%@ score=%d startedOn=%@ stopedOn=%@ totaltime=%f questions=%@ hintused=%@", _quizeNmuber, _type,_quizediscription,[_score intValue],_startedOn,_stopedOn,_quizeDuration,_arrayOfQuestions,_hintused ? @"Yes" : @"No"];
}
@end
