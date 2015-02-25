//
//  QuizeQuestionsDetailViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/21/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

/*
 
 [Main] Class that will prent user's Quize as UI Table view but we have an abiliyt to morph into UI Page view as well
 
 Only one input : quizeObject ( we work off of that object in this class )
 
 */

#import "QuizeQuestionsDetailViewController.h"
#import "quizeQuestionDetailsPageView.h"
#import "CommonUtils.h"
#import "quizeQuestionDetailsPageView.h"
#import "CommonStuffHeader.h"
#import "AssetFilesUtils.h"

#import "SizableImageCell.h"

@interface QuizeQuestionsDetailViewController ()

@end

@implementation QuizeQuestionsDetailViewController {
    
    BOOL isPageViewShwon;
    NSInteger currentQuestion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    // Main input - if this is nill we don't do anything 
    self.quize = (quizeObject*)self.input;
    
    if(self.quize)
    {
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIFont fontWithName:FONT_STYLE size:18.0], NSFontAttributeName,
                                                   [UIColor blackColor], NSForegroundColorAttributeName,
                                                   nil] ;
        // Add text to Bottom tool bar with Font style
        self.quizeSocreBottomToolBarToalQuestions.title = [NSString stringWithFormat:@"Score : %@",[self.quize.score stringValue]];
        [self.quizeSocreBottomToolBarToalQuestions setTitleTextAttributes:navbarTitleTextAttributes
                                  forState:UIControlStateNormal];
        self.quizeScoreBottomBarScore.title = [NSString stringWithFormat:@"Total time :%@",[CommonUtils formattedStringForDuration:self.quize.quizeDuration]];
        [self.quizeScoreBottomBarScore setTitleTextAttributes:navbarTitleTextAttributes
                                                                 forState:UIControlStateNormal];
        
        // Set nav title to Quize number
        self.navigationBar.topItem.title = [NSString stringWithFormat:@"Quize #:%@",self.quize.quizeNmuber];
        
        
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];

    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data" message:@"Input quize object is empty ..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    

    // delegate from quizeQuestionDetailsPageView - if user slides pages in Page view we want to also select same row in UI Table view in background
    // so when user comes back to UI Table view same row is selected and highlighted for them
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

// How many rows in this UI Table view == Number of questions in Quize
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quize.arrayOfQuestions.count;
}

// Get each Cell [formated using data from each quesiton from Quize ]
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UILabel* questionDuration = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    
    
    
    // Current Question we are working on
    quizeQuestion *q = self.quize.arrayOfQuestions[indexPath.row];
    NSString *LABLEText = [ NSString stringWithFormat:@"%@",q.question];
   cell.textLabel.text = LABLEText;
    

    
    NSString *detailtext = [[NSString alloc] init];
    
    UIImageView* correctOrIncorrect = (UIImageView*)[cell.contentView viewWithTag:89];
    
    
    if(correctOrIncorrect == nil)
    {
        correctOrIncorrect = [[UIImageView alloc] initWithFrame: CGRectMake( cell.frame.size.width-105, cell.frame.size.height/2-10, 35, 15 )];
    }
    
    
    
    
    if(q.correctOnfirstAtempt){
        //detailtext = @"0 attempts";
        //cell.backgroundColor = [UIColor colorWithRed:0.73 green:0.96 blue:0.65 alpha:1.0];
        correctOrIncorrect.image = [ UIImage imageNamed:ICON_CORRECT];
    }
    else if(q.arrayofWrrongAnswers.count > 0)
    {
        detailtext = [NSString stringWithFormat:@"%ld attempts",q.arrayofWrrongAnswers.count ];
        correctOrIncorrect.image = [ UIImage imageNamed:ICON_INCORRECT];
        // cell.backgroundColor =  [UIColor colorWithRed:0.88 green:0.65 blue:0.60 alpha:1.0];
    }
    else
    {
        detailtext = [NSString stringWithFormat:@"incomplete" ];
        //cell.backgroundColor =  [UIColor colorWithRed:0.95 green:0.27 blue:0.27 alpha:1.0];
        correctOrIncorrect.image = [ UIImage imageNamed:ICON_INCOMPLETE];
        
        
    }
    cell.detailTextLabel.text = detailtext;
    
    correctOrIncorrect.contentMode = UIViewContentModeScaleAspectFit;
    correctOrIncorrect.tag = 89;
    [cell.contentView addSubview:correctOrIncorrect];
    
//    UIImageView* countryImg = (UIImageView*)[cell.contentView viewWithTag:79];
//    
//    
//    if(countryImg == nil)
//    {
//        countryImg = [[UIImageView alloc] initWithFrame: CGRectMake( 0, cell.frame.size.height/2-10, 35, 15 )];
//    }
//    NSString *questionImage = [AssetFilesUtils CountryNametoFileName:q.question];
//    countryImg.image = [UIImage imageNamed:questionImage];
//    countryImg.contentMode = UIViewContentModeScaleAspectFit;
//    countryImg.tag = 79;
//    [cell.contentView addSubview:countryImg];
    
    

    
    // Set question duraiton ( how long it took to answer this Question )- on fart right hand side of cell 
    UILabel* questionDuration = (UILabel*)[cell.contentView viewWithTag:99];
    
    if(questionDuration == nil)
    {
        questionDuration = [[UILabel alloc] initWithFrame: CGRectMake( cell.frame.size.width-120, 0.0, 80, 44.0 )];
    }
    
    questionDuration.font = [UIFont systemFontOfSize: 11];
    questionDuration.textAlignment = NSTextAlignmentRight;
    questionDuration.textColor = [UIColor FONT_COLOR_FOR_DURATION];
    questionDuration.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    questionDuration.backgroundColor = [UIColor BACKGROUND_COLOR_FOR_DURATION];
    questionDuration.text = [CommonUtils formattedStringForDuration:q.duration]; // mm:ss minutes:seconds
    questionDuration.tag = 99; // so we can pullout when we dequeueReusableCellWithIdentifier ( re-use)
    [cell.contentView addSubview:questionDuration];
    
    
    
    
    return cell;
    
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    
//    if(!self.quizeUITableView.hidden){
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//    }
//    else
//    {
//       [self showPageView:nil ];
//    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];

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


@end
