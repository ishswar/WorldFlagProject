//
//  GameBoardViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/17/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

///################################################################
/*
THIS IS A COMMON CLASS BETWEEN TWO VIEW IN STORY BOARD 
 
 GAME BOARD - > Runs the game / keeps the timer
 GAME RESULT BOARD - > Shows Reslut of Game
 
*/

//################################################################
#import "GameBoardViewController.h"
#import "AssetFilesUtils.h"
#import "CommonUtils.h"
#import "CommonStuffHeader.h"
#import "QuizeQuestionsDetailViewController.h"
#import "mainTabBarController.h"


#define GAME_OVER_AT 0
#define GAME_TIME ((int)5)
#define GAME_TIME_BUMP ((int)3)
#define BUTTON_COLOR lightGrayColor
#define BUTTON_BORDER_COLOR blackColor
#define BUTTON_BORDER_WIDTH 0.4f

#define TIME_BETWEEN_TWO_QUESTIONS 0.2

#define CORRECT_ANSWER_BUTTONCOLOR greenColor
#define WRRONG_ANSWER_BUTTONCOLOR redColor

@interface GameBoardViewController ()

@end

@implementation GameBoardViewController {
    
    // We start this timer as start of game - it increments by +1 seconds
    NSTimer *gamesTimer;
    // We initalize this counter with GAME_TIME and then reduce it till we reach 0 - Game over at 0
    int counterValue;

    // Counter for correct answers / score
    int correctAnswers;
    // Did user answer question on first try
    BOOL correctAnswerOnFirstTry;
    
    // int used during showing score on Reslut screen - will start from 0 -> go till final score
    int currentCounterValueForAnimation;
    
    // Array containing all the Questions [ Flags image names ] from directory
    NSMutableArray * directoryContents;
    
    // Correct answer / image / flage name for this this Question ( on every next move this will change )
    NSString *correctCountry;
    
    // Quize object ( that will hold all the Questions of quize
    quizeObject *thisQuize;
    
    // Array that will keep track of all the quesitons of quize ( made up of quizeQuestion object )
    NSMutableArray *quizeQuestions;
    
    // one of the quie Question
    quizeQuestion * currentQuestion;
    
    // Array that will keep track of wrrong answers for above currentQuestion
    NSMutableArray *wrrongAnswers;
    
    // Is question already been answered ?
    BOOL currentQestionAlreadyAnsered;
    
    
    // For Reslut view
    
    NSTimer *reslutShowingTimer;
    
    NSInteger hightScore;
    NSMutableDictionary *highScoreDic;
    
    NSUserDefaults *userdef;
    
    NSInteger gametimeFromNSDef;
    
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // secret gestrue that will enable hint
    UISwipeGestureRecognizer *swipeForHint = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showHintLable:)];
    [swipeForHint setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeForHint setDelaysTouchesBegan:YES];
    [swipeForHint setNumberOfTouchesRequired:2];
    [[self view] addGestureRecognizer:swipeForHint];
    
    // hide the hint by defalut
    self.hintTextLable.hidden = YES;
    
    // Added two notification listner
    // for App going in background - so we can save stuff to NSUser default
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goBackground)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    // for App comming back from background ( Read stuff from NSUser default
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(comeBackFromBackground)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    
     userdef = [ NSUserDefaults standardUserDefaults];
    

        
    
    
    // This class is ahred by two View - so if score is there then we need to take care of Score screen
    
    // if game status id defined != nil that means we need to show Reslut else we start game
    if(self.gameStatus)
    {
        if(self.newHighScore){
        self.confetti = [[confettiViewController alloc] init];
        
        //Create emitterLayer & configure its various properties
        [self.confetti setupEmitter:self];
        
        //Create emitter cells for gold stars and confetti, set their properties and add them to the emitter
        [self.confetti setupEmitterCells];
        
        CGPoint startpoint = CGPointMake(75, 40);
        [self.confetti touchesEnded:startpoint];
        
        }
        
        self.QuizeOverTimesUpView.hidden = NO;
        // self.ResultLable.text = [@(self.score) stringValue];
        [self showReslutWithCounter];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        

        
    }
    else if(self.score == 0 ) // if not we start the game
    {
        // Read the directory and get all the file names as Questions
        directoryContents =  [[AssetFilesUtils getAllassetFiles] mutableCopy];
        
        if(directoryContents.count > 0)
        {
            
            //  [self resetAllButtons];
            
            // Get first question and prepare the Quize view
            [self doNextMove];
            // Start the Game ( mainly the counter )
            
            
            //NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            
            gametimeFromNSDef = [userdef integerForKey:GAME_TIMER_NAME_FOR_NSUSERDEFAULT];
            //NSLog(@"timer value is %lu",(long)gametimeFromNSDef);
            if(gametimeFromNSDef == 0){
                gametimeFromNSDef = GAME_TIME;
                [CommonUtils setGameTimeInUserDef:gametimeFromNSDef];
            }
            
            [self startGame:[NSNumber numberWithInteger:gametimeFromNSDef] startScore:[NSNumber numberWithInt:0]];
            
            highScoreDic = [[userdef dictionaryForKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY] mutableCopy];
            
            
            if(highScoreDic != nil)
            {
                 hightScore = [[highScoreDic objectForKey:[@(gametimeFromNSDef) stringValue]] integerValue];
                
                
            } else
            {
                [userdef setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],[@(gametimeFromNSDef) stringValue], nil] forKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY];
            }
            
            self.score = 0; // initalize game with this score - e.g 0 ?
            self.currentScore.text = [@(self.score) stringValue];
            
            /*
             At the end of game self.score == self.Correctimages.count
             */
            
            // Correct Images ( in other word - answers that user guessed it on first try )
            // we use this images in Reslut view
            self.CorrectImages = [[NSMutableArray alloc] init];
            
            // Init the Quize object for recording purpose
            [self initalizeQuizeObject];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data" message:@"No images found to start Game/Quize" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            self.textQuestionLabel.text =@"No data";
        }
        
        
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(void)viewDidDisappear:(BOOL)animated
{

    // Housekeeping of Objects

    directoryContents= nil;
    correctCountry= nil;
    quizeQuestions= nil;
    currentQuestion= nil;
    wrrongAnswers= nil;
    currentQestionAlreadyAnsered= nil;
    gamesTimer = nil;
    thisQuize = nil;
    self.confetti = nil;
}

-(void)showHintLable:(NSObject*)obj
{
    thisQuize.hintused = YES;
    if(self.hintTextLable.hidden)
    {
        self.hintTextLable.hidden = NO;
        
    }
    else
        self.hintTextLable.hidden = YES;
}

// ---- START : Reslut Screen

// Start showing Reslut with counting(++) up to reslut score
-(void)showReslutWithCounter
{
    
    reslutShowingTimer = [NSTimer scheduledTimerWithTimeInterval:.2 // fire every .09 seconds
                                                          target:self
                                                        selector:@selector(updateReslutLable:)
                                                        userInfo:nil
                                                         repeats:YES];
    currentCounterValueForAnimation = 0;
    
    [self.flagReslutsImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.flagReslutsImageView.layer setBorderWidth: 0.5];
}

-(void)updateReslutLable:(NSTimer*)intimer
{
    //NSLog(@"Flags %@",self.CorrectImages);
    if(currentCounterValueForAnimation < self.score)
    {
        NSString *imageName = [AssetFilesUtils CountryNametoFileName:self.CorrectImages[currentCounterValueForAnimation]];
        //NSLog(@"File looking for %@",imageName);
        self.flagReslutsImageView.image = [UIImage imageNamed:imageName];
        currentCounterValueForAnimation++; // increment uptill we reach score
        self.ResultLable.text = [@(currentCounterValueForAnimation) stringValue];

    }
    else {
//        [intimer invalidate]; // Stop the counter
//        intimer = nil;
        [self killTimer:intimer];

    }
    
    
}
// ---- END : Reslut Screeen




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"showResults"])
    {
        GameBoardViewController *gb = segue.destinationViewController;
        gb.score = [self.currentScore.text intValue];
        
        
        
        gb.CorrectImages = self.CorrectImages;
        gb.gameStatus = @"Over";
        gb.quize = thisQuize;
        gb.flagToText = self.flagToText;
        gb.newHighScore = self.newHighScore;
        
       NSLog(@"this Quize array %@",thisQuize);
    }
    
    if([segue.identifier isEqualToString:@"showQuizeResultInDetail"])
    {
        QuizeQuestionsDetailViewController *qqdvc = segue.destinationViewController;
        qqdvc.input = self.quize;
    }
    
    if([segue.identifier isEqualToString:@"reStartGame"])
    {
        GameBoardViewController *gbvc = segue.destinationViewController;
        gbvc.flagToText = self.flagToText;
    }
    
    if([segue.identifier isEqualToString:@"goStudy"])
    {
        mainTabBarController *gbvc = segue.destinationViewController;
        gbvc.selected_index = 1;
    }
}


//- (IBAction)gameOver:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"showResults" sender:nil];//IndexPath as sender
//}
- (IBAction)reStart:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"reStartGame" sender:self];//IndexPath as sender
    
    
}

- (IBAction)goHome:(UIButton *)sender {
    //goGameHome
    [self performSegueWithIdentifier:@"goGameHome" sender:self];//IndexPath as sender
}

- (IBAction)reStartQuize:(UIButton *)sender {
    [self performSegueWithIdentifier:@"reStartGame" sender:self];
}

- (IBAction)showDetails:(UIButton *)sender {
    [self performSegueWithIdentifier:@"showQuizeResultInDetail" sender:self];
}

- (IBAction)goBackHome:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goGameHome" sender:self];
}

- (IBAction)goToStudy:(UIButton *)sender {
    
    //goStudy

    [self performSegueWithIdentifier:@"goStudy" sender:self];
}

// ======= Game Controlles

-(void)initalizeQuizeObject
{
    thisQuize = [[quizeObject alloc] init];
    
    thisQuize.quizeNmuber = [NSNumber numberWithInt:0];
    
    if(self.flagToText)
        thisQuize.type = FlagtoText;
    else
        thisQuize.type = TexttoFlag;
    
    NSLog(@"Quize type is %d",thisQuize.type);
    
    thisQuize.quizediscription = @"World Flag games";
    
}

#pragma mark [Game Control]
-(void)startGame:(NSNumber*)counterval startScore:(NSNumber*)startScore
{

    counterValue = counterval.intValue; // We start counter with max and then go down every second
    correctAnswers = startScore.intValue; // 0 - unless we are restarting the game from background
    correctAnswerOnFirstTry = TRUE;
    
    // Show the current score
    [self updateAnswerLabl];
    
    // if CorrectImages is not init yet - init it
    if(!self.CorrectImages)
    self.CorrectImages = [[NSMutableArray alloc] init];
    
    // Game timer fire every 1 secdons
    gamesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateLabel:)
                                           userInfo:nil
                                            repeats:YES ];

    
    [self.questionImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.questionImage.layer setBorderWidth: 0.5];
    
    // Init the array that will keep track of all the Question(s) for Quize
    quizeQuestions = [[NSMutableArray alloc] init];
    
    currentQestionAlreadyAnsered = NO;
    

}

-(void)resetAllButtons:(BOOL)hidetext
{
    [self setButtonToDefalut:self.anser1Button1 hidtext:hidetext];
    [self setButtonToDefalut:self.anser2Button2 hidtext:hidetext];
    [self setButtonToDefalut:self.anser3Button3 hidtext:hidetext];
    [self setButtonToDefalut:self.ansser4Button4 hidtext:hidetext];
    
}

-(void)setButtonToDefalut:(UIButton*)button hidtext:(BOOL)hidetext;
{
    button.backgroundColor = [UIColor BUTTON_COLOR];
    button.layer.borderColor = [[UIColor BUTTON_BORDER_COLOR] CGColor];
    button.layer.borderWidth=BUTTON_BORDER_WIDTH;
    if(hidetext)
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}


// Game timer Stuff
- (void)updateLabel:(id)sender{
    
    if(!self.timeLeft.text)
        [self killTimer:gamesTimer];
    
    if(counterValue <= GAME_OVER_AT){ // We reached 0
        //NSLog(@"Gavem over counterValue is %ld & lable value is %@",(long)counterValue,self.timeLeft.text);
        

        
        [self killTimer:gamesTimer];
        
        if(currentQuestion.question){
        [quizeQuestions addObject:currentQuestion];
        NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:currentQuestion.startTime];
        currentQuestion.duration = distanceBetweenDates;
        currentQuestion.arrayofWrrongAnswers = wrrongAnswers;
            
        }
        

        // Record things for this Quize / Game
        thisQuize.stopedOn = [NSDate date];
        thisQuize.quizeDuration = [thisQuize.stopedOn timeIntervalSinceDate:thisQuize.startedOn];
        thisQuize.arrayOfQuestions = quizeQuestions;
        thisQuize.score = [NSNumber numberWithInteger:[self.currentScore.text integerValue] ];
        
        if(thisQuize.score.integerValue > hightScore)
        {
           // [userdef setObject:<#(id)#> forKey:<#(NSString *)#>:thisQuize.score.integerValue forKey:GAME_ALL_TIME_HIGHT_SCORE];
           // highScoreDic = [userdef dictionaryForKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY];

            
            if(highScoreDic != nil)
                highScoreDic = [[userdef dictionaryForKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY] mutableCopy];

            hightScore = thisQuize.score.integerValue;
            [highScoreDic setValue:[NSNumber numberWithInteger:hightScore] forKey:[@(gametimeFromNSDef) stringValue]];
           
            [userdef setObject:highScoreDic forKey:GAME_ALL_TIME_HIGHT_SCORE_DICTIONARY];
            [userdef synchronize];
            self.newHighScore = YES;
            thisQuize.highestscore = YES;
            
        }
        
        
        // Move out of this Game/Quize screen
        [self performSegueWithIdentifier:@"showResults" sender:nil];//This will chagne the screen for user so they can't keep laying
    }
    else {
    // keep reducing counter untill we reach GAME_OVER_AT number
    self.timeLeft.text = [NSString stringWithFormat:@"%d", counterValue];
    counterValue--;
    //NSLog(@"#---------------# : Gavem over counterValue is %ld & lable value is %@",(long)counterValue,self.timeLeft.text);

    }
    
}

// kill the game timer
- (void)killTimer:(NSTimer*)intimer{
    if(intimer){
        [intimer invalidate];
        intimer = nil;
    }
}

#pragma mark [ Game moves ]
-(void)doNextMove
{
    if(thisQuize.startedOn == nil)
    thisQuize.startedOn = [ NSDate date];
    
    if(counterValue >= 0){
        
        
        NSArray *temImgId = [self getEightRandomLessThan:[@(directoryContents.count) intValue]];
        NSArray *temImg_Id = [self getEightRandomLessThan:4];
        NSInteger countryWeareGoingtoPick = [temImgId[[temImg_Id[0] integerValue]] integerValue];
        correctCountry = directoryContents[countryWeareGoingtoPick];
        correctCountry = [AssetFilesUtils formatCountryName:correctCountry];
        
        
        
        NSLog(@"Correct country %@",correctCountry);
        self.hintTextLable.text = correctCountry;
        
        
        NSString *option1 = [AssetFilesUtils formatCountryName:directoryContents[[temImgId[1] intValue]]];
        NSString *option2 = [AssetFilesUtils formatCountryName:directoryContents[[temImgId[2] intValue]]];
        NSString *option3 = [AssetFilesUtils formatCountryName:directoryContents[[temImgId[0] intValue]]];
        NSString *option4 = [AssetFilesUtils formatCountryName:directoryContents[[temImgId[3] intValue]]];
        
        
        
        // self.flagToText == YES : Quize type [ Image and 4 text base choice ]
        // self.flagToText == NO : Quize type [ Text and 4 image base choice ]
        if(self.flagToText){
            
            self.textQuestionLabel.hidden = YES;
            self.questionImage.image = [UIImage imageNamed:directoryContents[[temImgId[[temImg_Id[0] intValue]] intValue] ]];
            
            //self.questionImage.transform = CGAffineTransformMakeRotation((30.0f * M_PI) / 180.0f);
            
            [self.anser1Button1 setTitle:option1 forState:UIControlStateNormal];
            
            [self.anser2Button2 setTitle:option2 forState:UIControlStateNormal];
            
            [self.anser3Button3 setTitle:option3 forState:UIControlStateNormal];
            
            [self.ansser4Button4 setTitle:option4 forState:UIControlStateNormal];
            

            // Reset button and don't hide button text
            [self resetAllButtons:NO];
            
        }
        else
        {

            self.questionImage.hidden = YES;
            self.textQuestion.hidden = NO;
            self.textQuestionLabel.text = correctCountry;
            self.textQuestionLabel.layer.backgroundColor=[[UIColor BUTTON_COLOR] CGColor];;
            
            [self.anser1Button1 setTitle:option1 forState:UIControlStateNormal];
            
            [self.anser2Button2 setTitle:option2 forState:UIControlStateNormal];
            
            [self.anser3Button3 setTitle:option3 forState:UIControlStateNormal];
            
            [self.ansser4Button4 setTitle:option4 forState:UIControlStateNormal];
            

            [self.anser1Button1 setImage:[UIImage imageNamed:directoryContents[[temImgId[1] intValue] ]] forState:UIControlStateNormal];

            [self.anser2Button2 setImage:[UIImage imageNamed:directoryContents[[temImgId[2] intValue] ]] forState:UIControlStateNormal];

            [self.anser3Button3 setImage:[UIImage imageNamed:directoryContents[[temImgId[0] intValue] ]] forState:UIControlStateNormal];

            [self.ansser4Button4 setImage:[UIImage imageNamed:directoryContents[[temImgId[3] intValue] ]] forState:UIControlStateNormal];
            
            // Reset buttons and hide the button text
            [self resetAllButtons:YES];
            
            
        }
        
        currentQuestion = [[quizeQuestion alloc] init];
        wrrongAnswers = [[NSMutableArray alloc] init];
        
        currentQuestion.arrayofOptions = @[option1,option2,option4,option3];
        currentQuestion.question = correctCountry;
        currentQuestion.answer = correctCountry;
        currentQuestion.startTime = [NSDate date];
        
        currentQestionAlreadyAnsered = NO;
        correctAnswerOnFirstTry = TRUE;
        
        [directoryContents removeObjectAtIndex:countryWeareGoingtoPick];
        
        
    }
    
}

- (IBAction)answer1ButtonPressed:(UIButton *)sender {
    [self handelCountryButtonPressed:sender];
}

- (IBAction)answer2ButtonPressed:(UIButton *)sender {
    [self handelCountryButtonPressed:sender];
}

- (IBAction)answer3ButtonPressed:(UIButton *)sender {
    [self handelCountryButtonPressed:sender];
}

- (IBAction)answer4ButtonPressed:(UIButton *)sender {
    [self handelCountryButtonPressed:sender];
}

-(void)handelCountryButtonPressed:(UIButton*)button
{
    if(!currentQestionAlreadyAnsered){
        if([self CheckAnser:button]){
            button.backgroundColor = [UIColor CORRECT_ANSWER_BUTTONCOLOR];
            button.layer.borderColor = [UIColor CORRECT_ANSWER_BUTTONCOLOR].CGColor;
            button.layer.borderWidth = 2.0f;

            //if answer is correct and go it on first attempt give user point + 3 seconds extra
            [self bumpPointAndCounter:button];
            // [self next:sender];
            // Show next question - but after 2 ms delay
            [self performSelector:@selector(doNextMove) withObject:nil afterDelay:TIME_BETWEEN_TWO_QUESTIONS];

            
            // Record question spesifics
            
            currentQuestion.answertime = [NSDate date];
            NSTimeInterval distanceBetweenDates = [currentQuestion.answertime timeIntervalSinceDate:currentQuestion.startTime];
            currentQuestion.arrayofWrrongAnswers = wrrongAnswers;
            currentQuestion.duration = distanceBetweenDates;
            [quizeQuestions addObject:currentQuestion];
            currentQestionAlreadyAnsered = YES;
            
        }
        else {
            button.backgroundColor = [UIColor WRRONG_ANSWER_BUTTONCOLOR];
            button.layer.borderColor = [UIColor WRRONG_ANSWER_BUTTONCOLOR].CGColor;
             button.layer.borderWidth = 2.0f;
            correctAnswerOnFirstTry = FALSE;
            [wrrongAnswers addObject:button.titleLabel.text];
        }
    }
    
    
}

// If user answers question on first attempt give them point and extra time for remaining questions
- (IBAction)bumpPointAndCounter:(UIButton *)button {
    
    if(correctAnswerOnFirstTry){
        currentQuestion.correctOnfirstAtempt = correctAnswerOnFirstTry;
        if (counterValue+GAME_TIME_BUMP <= GAME_TIME ) {
            counterValue = counterValue + GAME_TIME_BUMP;
        }
        
        // Populate the correct Images Array for Reslut view 
        NSString *correctImage = button.titleLabel.text;
        [self.CorrectImages addObject:correctImage];
        
        
        // increment score / answer count
        correctAnswers++;
        //update the lable
        [self updateAnswerLabl];
        
    }
    
}




#pragma mark [Utilities]

-(BOOL)CheckAnser:(UIButton*)button
{
    NSString *tempAnswer = button.titleLabel.text;
    
    if([tempAnswer isEqualToString:correctCountry])
    {
        
        return YES;
    }
    else{
        return NO;
    }
}
-(void)updateAnswerLabl
{
    
    self.currentScore.text = [@(correctAnswers) stringValue];
}

// Get Random number in Array
-(NSMutableArray *)getEightRandomLessThan:(int)M {
    NSMutableArray *listOfNumbers = [[NSMutableArray alloc] init];
    for (int i=0 ; i<M ; ++i) {
        [listOfNumbers addObject:[NSNumber numberWithInt:i]]; // ADD 1 TO GET NUMBERS BETWEEN 1 AND M RATHER THAN 0 and M-1
    }
    NSMutableArray *uniqueNumbers = [[NSMutableArray alloc] init];
    int r;
    while ([uniqueNumbers count] < 4) {
        r = arc4random() % [listOfNumbers count];
        if (![uniqueNumbers containsObject:[listOfNumbers objectAtIndex:r]]) {
            [uniqueNumbers addObject:[listOfNumbers objectAtIndex:r]];
        }
    }
    
    return uniqueNumbers;
}

//
// ------ Handle App's background processing
//

// Stuff to do when app is going to background
- (void) goBackground {
    

    if([self isEqual:[self getTopMostUIViewController]]){
        
        if(!self.gameStatus){

            [self killTimer:gamesTimer];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:[NSNumber numberWithInt:counterValue] forKey:@"currecntTimerValue"];
            [def setObject:[NSNumber numberWithInt:correctAnswers] forKey:@"correctAnswers"];
        }else{
            if(reslutShowingTimer)
            {
                [self killTimer:reslutShowingTimer];
            }
        }
    }
}

// Stuff to do when app is comming back from background
-(void)comeBackFromBackground{

    
    if([self isEqual:[self getTopMostUIViewController]] ){
        
        if(!self.gameStatus){
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [def objectForKey:@"currecntTimerValue"];
        // counterValue = num.intValue;
       // NSLog(@"counterValue %@",num);
        
        NSNumber *numanswers = [def objectForKey:@"correctAnswers"];
        //  correctAnswers = numanswers.intValue;
        //NSLog(@"correctAnswers %@",numanswers);
        
       // NSLog(@"Correct images %@",self.CorrectImages);
        
        
        [self startGame:num startScore:numanswers];
        }
        else{
            if(currentCounterValueForAnimation < self.score)
            {
            [self showReslutWithCounter];
            }
        }
    }
    
    
}

-(UIViewController*)getTopMostUIViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    // Get to top most Controller that is what we need to work with
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (IBAction)ResultLableButton:(id)sender {
}
@end
