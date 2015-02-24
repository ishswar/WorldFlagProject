//
//  quizeQuestionDetailsPageView.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/22/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "quizeQuestionDetailsPageView.h"
#import "quizeQuestionDetailsPageViewBottomViewController.h"

@interface quizeQuestionDetailsPageView ()

@end

@implementation quizeQuestionDetailsPageView {
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if(!self.quize) {
    quizeQuestion *q1 = [[quizeQuestion alloc] init];
    q1.question = @"Test1_Options1";
    NSArray *options = @[@"Test1_Options1",@"Test1_Options2",@"Test1_Options3",@"Test1_Options4"];
    NSMutableArray *wrrongQ = [@[@"Test1_Options3",@"Test1_Options2"] mutableCopy];
    
    q1.arrayofWrrongAnswers = wrrongQ;
    q1.arrayofOptions = options;
    
    quizeQuestion *q2 = [[quizeQuestion alloc] init];
    q2.question = @"Test2_Options2";
    NSArray *options2 = @[@"Test2_Options1",@"Test2_Options2",@"Test2_Options3",@"Test2_Options4"];
    NSMutableArray *wrrongQ2 = [@[@"Test2_Options3",@"Test2_Options1",@"Test2_Options4"] mutableCopy];
    
    q2.arrayofWrrongAnswers = wrrongQ2;
    q2.arrayofOptions = options2;
    
    quizeQuestion *q3 = [[quizeQuestion alloc] init];
    q3.question = @"Test3_Options4";
    NSArray *options3 = @[@"Test3_Options1",@"Test3_Options2",@"Test3_Options3",@"Test3_Options4"];
    NSMutableArray *wrrongQ3 = [@[@"Test3_Options2"] mutableCopy];
    
    q3.arrayofWrrongAnswers = wrrongQ3;
    q3.arrayofOptions = options3;
    
    quizeQuestion *q4 = [[quizeQuestion alloc] init];
    q4.question = @"Test4_Options1";
    NSArray *options4 = @[@"Test4_Options1",@"Test4_Options2",@"Test4_Options3",@"Test4_Options4"];
    NSMutableArray *wrrongQ4 = [@[@"Test4_Options2",@"Test4_Options4"] mutableCopy];
    
    q4.arrayofWrrongAnswers = wrrongQ4;
    q4.arrayofOptions = options4;
    
    self.quize = [[quizeObject alloc] init];
    
    self.quize.arrayOfQuestions = [@[q1,q2,q3,q4] mutableCopy];
    }
    
    
    if(self.quize != nil)
    {
        
        self.quizeStartTimeAaboutQuizeLable.text = [self formateDate:self.quize.startedOn];
        self.quizeEndTimeAaboutQuizeLable.text = [self formateDate:self.quize.stopedOn];
        self.quizeDurationAaboutQuizeLable.text = [self formattedStringForDuration:self.quize.quizeDuration];//[NSString stringWithFormat:@"%f sec",self.quize.quizeDuration];
        self.quizeTotalQuestionsAaboutQuizeLable.text = [@(self.quize.arrayOfQuestions.count) stringValue];
        self.quizeScoreAboutQuizeLable.text = self.quize.score.stringValue;
        
    }
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    quizeQuestionDetailsPageViewBottomViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.bottomQuizeQuestionDetailView.frame.size.width, self.bottomQuizeQuestionDetailView.frame.size.height);
    
    self.pageViewController.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [self addChildViewController:_pageViewController];
    [self.bottomQuizeQuestionDetailView addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    

    self.pageViewController.view.backgroundColor = [UIColor whiteColor];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *myTextField = (UIButton *)[self.view viewWithTag:9];
   // myTextField.layer.borderStyle = UITextBorderStyleLine;
    myTextField.layer.borderWidth = 2;
    myTextField.layer.borderColor = [[UIColor redColor] CGColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((quizeQuestionDetailsPageViewBottomViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((quizeQuestionDetailsPageViewBottomViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.quize.arrayOfQuestions count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (quizeQuestionDetailsPageViewBottomViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.quize.arrayOfQuestions count] == 0) || (index >= [self.quize.arrayOfQuestions count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    quizeQuestionDetailsPageViewBottomViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"quizeQuestionDetailsPageViewBottomViewController"];
    //pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.questiontoShow = self.quize.arrayOfQuestions[index];
    pageContentViewController.quizeType = self.quize.type;
    NSLog(@"Quize type is %d",self.quize.type);
    pageContentViewController.pageIndex = index;
    
    
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.quize.arrayOfQuestions count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (IBAction)goBack:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(NSString*)formateDate:(NSDate*)date
{
    //NSDate *date         = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/YY hh:mm:ss"];
    NSString *dateString  = [df stringFromDate:date];
    
    return dateString;
    
}

- (NSString*)formattedStringForDuration:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
}

@end
