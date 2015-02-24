//
//  QuizeQuestionsDetailViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/21/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "QuizeQuestionsDetailViewController.h"
#import "quizeQuestionDetailsPageView.h"

#import "quizeQuestionDetailsPageView.h"

@interface QuizeQuestionsDetailViewController ()

@end

@implementation QuizeQuestionsDetailViewController {
    
        NSArray *myColors;
    BOOL isPageViewShwon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    myColors = @[@"black",@"brown",@"orange",@"red",@"blue",@"green",@"purple",@"yellow"];
    
    self.quize = (quizeObject*)self.input;
    
    if(self.quize)
    {
        NSLog(@"Quize size is %ld",self.quize.arrayOfQuestions.count);
        self.quizeSocreBottomToolBarToalQuestions.title = [NSString stringWithFormat:@"Score : %@",[self.quize.score stringValue]];
        self.quizeScoreBottomBarScore.title = [NSString stringWithFormat:@"Total time :%@",[self formattedStringForDuration:self.quize.quizeDuration]];
    }
    
//  //  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
//    
//   // UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                 //                                                   style:UIBarButtonItemStyleDone target:nil action:nil];
//    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Title"];
//  
//  //  item.hidesBackButton = YES;
//   // item.backBarButtonItem = backButton;
//    
//   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
//      item.leftBarButtonItem = backButton;
//    [self.navbar pushNavigationItem:item animated:NO];
    
   // self.navigationBar.topItem.prompt = [NSString stringWithFormat:@"Score : %@",self.quize.score];
    //self.navigationItem.prompt = [NSString stringWithFormat:@"Score : %@",self.quize.score];
    
    self.navigationBar.topItem.title = [NSString stringWithFormat:@"Quize #:%@",self.quize.quizeNmuber];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showQuizePageView"])
    {
        quizeQuestionDetailsPageView *qQDPV = segue.destinationViewController;
        qQDPV.quize = self.quize;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quize.arrayOfQuestions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel* questionDuration = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    quizeQuestion *q = self.quize.arrayOfQuestions[indexPath.row];
    NSString *LABLEText = [ NSString stringWithFormat:@"%@",q.question];
    cell.textLabel.text = LABLEText;
    
    NSString *detailtext = [[NSString alloc] init];
    if(q.correctOnfirstAtempt){
       //detailtext = @"0 attempts";
        cell.backgroundColor = [UIColor colorWithRed:0.73 green:0.96 blue:0.65 alpha:1.0];
    }
    else if(q.answertime)
    {
        detailtext = [NSString stringWithFormat:@"%ld attempts",q.arrayofWrrongAnswers.count ];
        cell.backgroundColor =  [UIColor colorWithRed:0.88 green:0.65 blue:0.60 alpha:1.0];
    }
    else
    {
        detailtext = [NSString stringWithFormat:@"incomplete" ];
        cell.backgroundColor =  [UIColor colorWithRed:0.95 green:0.27 blue:0.27 alpha:1.0];
    }
   cell.detailTextLabel.text = detailtext;
    
    //UILabel *scorelable = (UILabel *)[cell viewWithTag:13];
    //scorelable.text = [self formattedStringForDuration:q.duration];
    
    questionDuration = [[UILabel alloc] initWithFrame: CGRectMake( cell.frame.size.width-120, 0.0, 80, 44.0 )];
    questionDuration.tag = 22;
    questionDuration.font = [UIFont systemFontOfSize: 11];
    questionDuration.textAlignment = NSTextAlignmentRight;
    questionDuration.textColor = [UIColor blueColor];
    questionDuration.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    questionDuration.backgroundColor = [UIColor clearColor];
    questionDuration.text = [self formattedStringForDuration:q.duration];
    [cell.contentView addSubview: questionDuration];

    
    return cell;
    
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)showPageView:(UIBarButtonItem *)sender {
    
    if(!self.quizeUITableView.hidden){
        
        self.quizeUITableView.hidden = YES;
        
        quizeQuestionDetailsPageView *viewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"splitPageView"];
        viewController.quize = self.quize;
        self.quizeScoreBottomToolBar.hidden = YES;
        viewController.view.frame = CGRectMake(self.quizeUITableView.frame.origin.x, self.quizeUITableView.frame.origin.y, self.quizeUITableView.frame.size.width, self.quizeUITableView.frame.size.height+self.quizeScoreBottomToolBar.frame.size.height);
        
        [self addChildViewController:viewController];
        viewController.view.tag  = 11;
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        sender.title = @"List";

        
    }
    else
    {
        
        
        UIViewController *vc = [self.childViewControllers lastObject];
        
        if([vc.restorationIdentifier isEqualToString:@"splitPageView"])
        {
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
            
            UIView *v = [self.view viewWithTag:11];
            [v removeFromSuperview];
            
            self.quizeUITableView.hidden = NO;
            self.quizeScoreBottomToolBar.hidden = NO;
            
            sender.title = @"Detail";
            
            
        }
        
    }

    

    
}

- (NSString*)formattedStringForDuration:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
}
@end
