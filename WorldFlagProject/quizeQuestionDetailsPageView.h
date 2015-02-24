//
//  quizeQuestionDetailsPageView.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/22/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "quizeObject.h"
#import "quizeQuestion.h"



@interface quizeQuestionDetailsPageView : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong,nonatomic) quizeObject *quize;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) IBOutlet UILabel *quizeNumberAaboutQuizeLable;

@property (strong, nonatomic) IBOutlet UILabel *quizeTotalQuestionsAaboutQuizeLable;

@property (strong, nonatomic) IBOutlet UILabel *quizeDurationAaboutQuizeLable;

@property (strong, nonatomic) IBOutlet UILabel *quizeStartTimeAaboutQuizeLable;

@property (strong, nonatomic) IBOutlet UILabel *quizeEndTimeAaboutQuizeLable;

@property (strong, nonatomic) IBOutlet UILabel *quizeScoreAboutQuizeLable;





@property (strong, nonatomic) IBOutlet UIView *bottomQuizeQuestionDetailView;
- (IBAction)goBack:(UIButton *)sender;

@end
