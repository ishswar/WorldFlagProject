//
//  FirstViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/12/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

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
 }
 

- (IBAction)startGame:(UIButton *)sender {
    
        [self performSegueWithIdentifier:@"startGame" sender:nil];//IndexPath as sender

}
@end
