//
//  settingsAndAboutViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/25/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "settingsAndAboutViewController.h"
#import "CommonStuffHeader.h"


@implementation settingsAndAboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    
    NSInteger timer = [userdef integerForKey:@"timer"];
    
    if(timer > 0)
    {
        self.quizeDuration.value = timer;
        self.showQuizeTime.text = [NSString stringWithFormat:@"%lu sec",timer];
    }
    else {
        self.quizeDuration.value = GAME_TIME;
        [userdef setInteger:GAME_TIME forKey:@"timer"];
        self.showQuizeTime.text = [NSString stringWithFormat:@"%d sec",GAME_TIME];
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    
    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    NSString *bundleName = infoDictionary[(NSString *)kCFBundleNameKey];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    

    
    self.aboutTextLable.text = [NSString stringWithFormat:@"World Flags Quiz \nCreator :Pranay Shah\n \nBuild : %@ \nbundleName %@ \nVersion : %@",build,bundleName,version];//;
    
}

- (IBAction)quizeDurationChanged:(UISlider *)sender {
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    
    NSInteger timer = [userdef integerForKey:@"timer"];
    
    if(timer > 0)
    {
        timer = roundf(sender.value);
        [userdef setInteger:timer forKey:@"timer"];
        self.showQuizeTime.text = [NSString stringWithFormat:@"%lu sec",timer];
    }
    
    
    
    
    
}
@end
