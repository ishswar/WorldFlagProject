//
//  SecondViewController.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/12/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)goHorizontal:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIView *horizontalView;
@property (strong, nonatomic) IBOutlet UILabel *horizontalCountryName;
@property (strong, nonatomic) IBOutlet UIImageView *horizontalCountryFlagImage;

- (IBAction)horizontalShowDetail:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *horizontalShowLable;
@end

