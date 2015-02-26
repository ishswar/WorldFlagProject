//
//  quizeQuestion.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/20/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol quizeQuesiton <NSObject>



@end

@interface quizeQuestion : NSObject

@property (strong,nonatomic) NSString* question;
@property (strong,nonatomic) NSString* answer;

@property (strong,nonatomic) NSDate* startTime;
@property (strong,nonatomic) NSDate* answertime;
@property (nonatomic) NSTimeInterval duration;
@property (strong,nonatomic) NSMutableArray* arrayofWrrongAnswers;
@property (strong,nonatomic) NSArray* arrayofOptions;
@property (nonatomic) BOOL correctOnfirstAtempt;



@end

