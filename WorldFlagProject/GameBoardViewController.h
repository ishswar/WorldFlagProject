//
//  GameBoardViewController.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/17/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "quizeQuestion.h"
#import "quizeObject.h"

@interface GameBoardViewController : UIViewController

// YES : Quize type [ Image and 4 text base choice ]
// NO : Quize type [ Text and 4 image base choice ]
@property (nonatomic) BOOL flagToText;

// If game is over this property will be set else nil (uninitialized )
@property (strong,nonatomic) NSString * gameStatus;

// Reslut view
@property (strong, nonatomic) IBOutlet UILabel *ResultLable;
@property (strong, nonatomic) IBOutlet UIImageView *flagReslutsImageView;
@property int score;
@property (strong,nonatomic) NSMutableArray* CorrectImages;

- (IBAction)reStart:(UIButton *)sender;
- (IBAction)goHome:(UIButton *)sender;


// Game Board
@property (strong, nonatomic) IBOutlet UIView *textQuestion;
@property (strong, nonatomic) IBOutlet UILabel *textQuestionLabel;

@property (strong, nonatomic) IBOutlet UILabel *hintTextLable;

@property (strong, nonatomic) IBOutlet UILabel *currentScore;
@property (strong, nonatomic) IBOutlet UILabel *timeLeft;

@property (strong, nonatomic) IBOutlet UIButton *anser1Button1;
@property (strong, nonatomic) IBOutlet UIButton *anser2Button2;
@property (strong, nonatomic) IBOutlet UIButton *anser3Button3;
@property (strong, nonatomic) IBOutlet UIButton *ansser4Button4;

- (IBAction)answer1ButtonPressed:(UIButton *)sender;
- (IBAction)answer2ButtonPressed:(UIButton *)sender;
- (IBAction)answer3ButtonPressed:(UIButton *)sender;
- (IBAction)answer4ButtonPressed:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIImageView *questionImage;

@property (strong,nonatomic) quizeObject * quize;


@end
