//
//  GameBoardViewController.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/17/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameBoardViewController : UIViewController

// Reslut view
@property (strong, nonatomic) IBOutlet UILabel *ResultLable;
- (IBAction)reStart:(UIButton *)sender;
- (IBAction)goHome:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *flagReslutsImageView;

@property int score;
@property (strong,nonatomic) NSMutableArray* CorrectImages;




// Game Board

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


@end
