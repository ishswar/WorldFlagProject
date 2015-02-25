//
//  settingsAndAboutViewController.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/25/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsAndAboutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISlider *quizeDuration;

- (IBAction)quizeDurationChanged:(UISlider *)sender;
@property (strong, nonatomic) IBOutlet UILabel *showQuizeTime;

@property (strong, nonatomic) IBOutlet UITextView *aboutTextLable;

@end
