//
//  QuizeQuestionsDetailViewController.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/21/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "quizeQuestion.h"
#import "quizeObject.h"

@interface QuizeQuestionsDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSObject * input;
@property (strong,nonatomic) quizeObject * quize;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *quizeSocreBottomToolBarToalQuestions;

@property (strong, nonatomic) IBOutlet UILabel *questionScoreLableInCell;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *quizeScoreBottomBarScore;

- (IBAction)goBack:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;


- (IBAction)showPageView:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITableView *quizeUITableView;

@property (strong, nonatomic) IBOutlet UIToolbar *quizeScoreBottomToolBar;

@end
