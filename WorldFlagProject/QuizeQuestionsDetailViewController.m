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
    NSInteger currentQuestion;
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
        [self.quizeSocreBottomToolBarToalQuestions setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"Chalkboard SE" size:18.0], NSFontAttributeName,
                                            [UIColor blackColor], NSForegroundColorAttributeName,
                                            nil] 
                                  forState:UIControlStateNormal];
        self.quizeScoreBottomBarScore.title = [NSString stringWithFormat:@"Total time :%@",[self formattedStringForDuration:self.quize.quizeDuration]];
        [self.quizeScoreBottomBarScore setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                           [UIFont fontWithName:@"Chalkboard SE" size:18.0], NSFontAttributeName,
                                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                                           nil]
                                                                 forState:UIControlStateNormal];
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
    
    self.qqdpv.delegate = self;
    
    
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
   // UILabel* questionDuration = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    quizeQuestion *q = self.quize.arrayOfQuestions[indexPath.row];
    NSString *LABLEText = [ NSString stringWithFormat:@"%@",q.question];
    cell.textLabel.text = LABLEText;
    
    NSString *detailtext = [[NSString alloc] init];
    if(q.correctOnfirstAtempt){
       //detailtext = @"0 attempts";
        //cell.backgroundColor = [UIColor colorWithRed:0.73 green:0.96 blue:0.65 alpha:1.0];
    }
    else if(q.arrayofWrrongAnswers.count > 0)
    {
        detailtext = [NSString stringWithFormat:@"%ld attempts",q.arrayofWrrongAnswers.count ];
       // cell.backgroundColor =  [UIColor colorWithRed:0.88 green:0.65 blue:0.60 alpha:1.0];
    }
    else
    {
        detailtext = [NSString stringWithFormat:@"incomplete" ];
        //cell.backgroundColor =  [UIColor colorWithRed:0.95 green:0.27 blue:0.27 alpha:1.0];
    }
   cell.detailTextLabel.text = detailtext;
    
    //UILabel *scorelable = (UILabel *)[cell viewWithTag:13];
    //scorelable.text = [self formattedStringForDuration:q.duration];
    
    
    
    UILabel* questionDuration = (UILabel*)[cell.contentView viewWithTag:99];
    
    if(questionDuration == nil)
    {
         questionDuration = [[UILabel alloc] initWithFrame: CGRectMake( cell.frame.size.width-120, 0.0, 80, 44.0 )];
    }
    
    questionDuration.font = [UIFont systemFontOfSize: 11];
    questionDuration.textAlignment = NSTextAlignmentRight;
    questionDuration.textColor = [UIColor blueColor];
    questionDuration.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    questionDuration.backgroundColor = [UIColor clearColor];
    questionDuration.text = [self formattedStringForDuration:q.duration];
    questionDuration.tag = 99;
    [cell.contentView addSubview:questionDuration];
    
    UIImageView* correctOrIncorrect = (UIImageView*)[cell.contentView viewWithTag:89];
    
    if(correctOrIncorrect == nil)
    {
        correctOrIncorrect = [[UIImageView alloc] initWithFrame: CGRectMake( cell.frame.size.width-65, cell.frame.size.height/2-10, 35, 15 )];
    }
    
//    questionDuration.font = [UIFont systemFontOfSize: 11];
//    questionDuration.textAlignment = NSTextAlignmentRight;
//    questionDuration.textColor = [UIColor blueColor];
//    questionDuration.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
//    questionDuration.backgroundColor = [UIColor clearColor];
    if(q.arrayofWrrongAnswers.count == 0 && q.answertime != nil)
        correctOrIncorrect.image = [ UIImage imageNamed:@"icon_correct.png"];
    else if(q.arrayofWrrongAnswers.count > 0)
        correctOrIncorrect.image = [ UIImage imageNamed:@"icon_incorrect.png"];
    else
        correctOrIncorrect.image = [ UIImage imageNamed:@"icon_incomplete.png"];

    correctOrIncorrect.contentMode = UIViewContentModeScaleAspectFit;

    
    //questionDuration.text = [self formattedStringForDuration:q.duration];
    correctOrIncorrect.tag = 89;
    [cell.contentView addSubview:correctOrIncorrect];

    
//    if(indexPath.row==currentQuestion){
//        [cell.contentView.layer setBorderColor:[UIColor yellowColor].CGColor];
//        [cell.contentView.layer setBorderWidth:2.0f];
//    }else {
//        [cell.contentView.layer setBorderColor:[UIColor clearColor].CGColor];
//        [cell.contentView.layer setBorderWidth:2.0f];
//    }
    return cell;
    
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    if(!self.quizeUITableView.hidden){
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    }
    else
    {
       [self showPageView:nil ];
    }
}

-(void)updateCurrentPageIndex:(NSInteger)index
{
    NSLog(@"Now Selected row is %ld",(long)index);
    NSIndexPath *ind = [ NSIndexPath indexPathForItem:index inSection:0];
    [self.quizeUITableView selectRowAtIndexPath:ind animated:NO scrollPosition:UITableViewScrollPositionMiddle];

    NSIndexPath *oldind = [ NSIndexPath indexPathForItem:currentQuestion inSection:0];

    UITableViewCell *before = [self.quizeUITableView cellForRowAtIndexPath:oldind];
    [before.layer setBorderColor:[UIColor clearColor].CGColor];
    [before.layer setBorderWidth:0.0f];
    
    UITableViewCell *now = [self.quizeUITableView cellForRowAtIndexPath:ind];
    [now.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [now.layer setBorderWidth:2.0f];
    
    currentQuestion = index;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *ind = [ NSIndexPath indexPathForItem:currentQuestion inSection:0];
    UITableViewCell *before = [self.quizeUITableView cellForRowAtIndexPath:ind];
    [before.layer setBorderColor:[UIColor clearColor].CGColor];
    [before.layer setBorderWidth:0.0f];
    
    currentQuestion = indexPath.row;
    
    UITableViewCell *now = [self.quizeUITableView cellForRowAtIndexPath:indexPath];
    [now.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [now.layer setBorderWidth:2.0f];

    [self showPageView:nil ];
}



- (IBAction)showPageView:(UIBarButtonItem *)sender {
    
    if(!self.quizeUITableView.hidden){
        
        self.quizeUITableView.hidden = YES;
        
        quizeQuestionDetailsPageView *viewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"splitPageView"];
        viewController.quize = self.quize;
        viewController.questontoShowFirst = [@(currentQuestion) intValue];
        viewController.delegate = self;
        self.quizeScoreBottomToolBar.hidden = YES;
        viewController.view.frame = CGRectMake(self.quizeUITableView.frame.origin.x, self.quizeUITableView.frame.origin.y, self.quizeUITableView.frame.size.width, self.quizeUITableView.frame.size.height+self.quizeScoreBottomToolBar.frame.size.height);
        
        [self addChildViewController:viewController];
        viewController.view.tag  = 11;
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        self.navigationBar.topItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_Details-50.png"];//@"List";

        
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
            
            self.navigationBar.topItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_Template-50.png"];//@"Detail";
            
            
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
