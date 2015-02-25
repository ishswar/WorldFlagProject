//
//  quizeQuestionDetailsPageViewBottomViewController.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/22/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "quizeObject.h"
#import "quizeQuestion.h"
@interface quizeQuestionDetailsPageViewBottomViewController : UIViewController


@property NSUInteger pageIndex;
@property (nonatomic) quizeType quizeType;
@property (strong,nonatomic) quizeQuestion * questiontoShow;
@property (strong, nonatomic) IBOutlet UIImageView *quizeQuestionImage;
@property (strong, nonatomic) IBOutlet UILabel *quizeQuestionTextHelperLable;

@property (strong, nonatomic) IBOutlet UILabel *quizeQuestionTextLabel;

@property (strong, nonatomic) IBOutlet UIButton *quizeQuestionOption1Button;

@property (strong, nonatomic) IBOutlet UIButton *quizeQuestionOption2Button;
@property (strong, nonatomic) IBOutlet UIButton *quizeQuestionOption3Button;

@property (strong, nonatomic) IBOutlet UIButton *quizeQuestionOption4Button;

@property (strong, nonatomic) IBOutlet UILabel *quizeQuestionNumber;


@property (strong, nonatomic) IBOutlet UILabel *quizeQuestionDuration;

@property (strong, nonatomic) IBOutlet UIImageView *correctWrrongImage;


@end
