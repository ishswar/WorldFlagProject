//
//  settingsAndAboutViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/25/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "settingsAndAboutViewController.h"
#import "CommonStuffHeader.h"


@implementation settingsAndAboutViewController {
    
    NSMutableDictionary *highScoreDic;
    
    NSUserDefaults *userdef;
    
    NSInteger gametimeFromNSDef;
    
     NSInteger hightScore;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    // Set the slider value to what is tored in NS Userver defalut else to defalut (GAME_TIMER_NAME_FOR_NSUSERDEFAULT)
    userdef = [NSUserDefaults standardUserDefaults];
    
    NSInteger timer = [userdef integerForKey:GAME_TIMER_NAME_FOR_NSUSERDEFAULT];
    
    if(timer > 0)
    {
        self.quizeDuration.value = timer;
        self.showQuizeTime.text = [NSString stringWithFormat:@"%lu sec",timer];
    }
    else {
        self.quizeDuration.value = GAME_TIME;
        [userdef setInteger:GAME_TIME forKey:GAME_TIMER_NAME_FOR_NSUSERDEFAULT];
        [userdef synchronize];
        self.showQuizeTime.text = [NSString stringWithFormat:@"%d sec",GAME_TIME];
    }
    
    highScoreDic = [[userdef dictionaryForKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY] mutableCopy];
    
    //NSLog(@"highScoreDic : %@",highScoreDic);
    
    
    if(highScoreDic != nil)
    {
        hightScore = [[highScoreDic objectForKey:[@(timer) stringValue]] integerValue];
        
        
    } else
    {
        [userdef setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timer],[@(gametimeFromNSDef) stringValue], nil] forKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY];
    }
    
    self.highScoreforThisLevel.text = [@(hightScore) stringValue];
    
    // Get build & Version number of App
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    
    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    NSString *bundleName = infoDictionary[(NSString *)kCFBundleNameKey];
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    // Credits to external sites
    NSString *imageCredit = @"http://www.free-country-flags.com/";
    NSString *iconCredit = @"http://icons8.com/web-app/for/ios7/details";
    

    // About text goes in UI Text View
    self.aboutTextLable.text = [NSString stringWithFormat:@"World Flags Quiz \n\n"
                                                 "Creator : Pranay Shah (pranay.shah@gmail.com)\n \n"
                                                  "BundleName : %@ \n"
                                                  "Version : %@.%@\n\n"
                                                   "Flag images are courtesy of : %@\n"
                                                   "App icons are courtesy of : %@"
                                                   ,bundleName,version,build,imageCredit,iconCredit];//;
    
}

// Change the game timer value and save it to NS Userver defalut 
- (IBAction)quizeDurationChanged:(UISlider *)sender {
    
    // Show current timer value of Quize
    userdef = [NSUserDefaults standardUserDefaults];
    
    NSInteger timer = [userdef integerForKey:GAME_TIMER_NAME_FOR_NSUSERDEFAULT];
    
    if(timer > 0)
    {
        timer = roundf(sender.value);
        [userdef setInteger:timer forKey:GAME_TIMER_NAME_FOR_NSUSERDEFAULT];
        [userdef synchronize];
        self.showQuizeTime.text = [NSString stringWithFormat:@"%lu sec",timer];
    }
    
    // Get high score from NSUser def and show it
    highScoreDic = [[userdef dictionaryForKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY] mutableCopy];
    
    if(highScoreDic != nil)
    {
        hightScore = [[highScoreDic objectForKey:[@(timer) stringValue]] integerValue];
        
        
    } else
    {
        [userdef setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timer],[@(gametimeFromNSDef) stringValue], nil] forKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY];
    }
    // Show the highScore
    self.highScoreforThisLevel.text = [@(hightScore) stringValue];
    
    
    
}
// Reset button handler - if press alert user but if they still want then we use "UIAlertViewDelegate" to capture user's call
- (IBAction)resetThisLevle:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really reset?" message:@"Do you really want to reset this high score?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

// Delegate method of UIAlertViewDelegate - this will get called is user says "Yes" to Reset .
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        highScoreDic = [[userdef dictionaryForKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY] mutableCopy];
        
        NSString *timer = [@(round(self.quizeDuration.value)) stringValue ];
        
        if(highScoreDic != nil)
        {
                [highScoreDic setObject:[NSNumber numberWithInt:0] forKey:timer];
            
        }
        hightScore = [[highScoreDic objectForKey:timer] integerValue];
        [userdef setObject:highScoreDic forKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY];
        [userdef synchronize];
        self.highScoreforThisLevel.text = [@(hightScore) stringValue];
    }
}

@end
