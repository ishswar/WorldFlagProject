//
//  quizeQuestion.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/20/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "quizeQuestion.h"

@implementation quizeQuestion


//@property (strong,nonatomic) NSString* question;
//@property (strong,nonatomic) NSString* answer;
//@property (nonatomic) int timetooktotal;
//@property (strong,nonatomic) NSDate* startTime;
//@property (strong,nonatomic) NSDate* answertime;
//@property (nonatomic) NSTimeInterval duration;
//@property (strong,nonatomic) NSMutableArray* arrayofWrrongAnswers;
- (NSString *)description {
    return [NSString stringWithFormat: @"Quize question : Question=%@ firstAttempt=%@ duration=%f startTime=%@ answerTime=%@ wrrongAnswer=%@ Options were=%@ ", _question, _correctOnfirstAtempt ? @"YES" : @"NO",_duration,_startTime,_answertime,_arrayofWrrongAnswers,_arrayofOptions];
}

@end
