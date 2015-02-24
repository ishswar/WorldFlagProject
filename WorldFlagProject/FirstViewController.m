//
//  FirstViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/12/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "FirstViewController.h"
#import "GameBoardViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
    
    // YES : Quize type [ Image and 4 text base choice ]
    // NO : Quize type [ Text and 4 image base choice ]
    BOOL flagtoText;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if([segue.identifier isEqualToString:@"startGame"])
     {
         GameBoardViewController *gbvc = segue.destinationViewController;
         gbvc.flagToText = flagtoText;
     }
     
 }
 
// Start Quize with Image as Question
- (IBAction)startGame:(UIButton *)sender {
    
    flagtoText = YES; // YES : Quize type [ Image and 4 text base choice ]
    [self performSegueWithIdentifier:@"startGame" sender:nil];//IndexPath as sender
    
    
}

// Start Quize with Text as Question
- (IBAction)startGameTexttoFlag:(UIButton *)sender {
    flagtoText = NO; // NO : Quize type [ Text and 4 image base choice ]
    [self performSegueWithIdentifier:@"startGame" sender:nil];//IndexPath as sender
    
}
@end
