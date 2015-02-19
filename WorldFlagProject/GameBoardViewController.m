//
//  GameBoardViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/17/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "GameBoardViewController.h"
#import "AssetFilesUtils.h"

#define GAME_OVER_AT 0
#define GAME_TIME ((int)25)
#define GAME_TIME_BUMP ((int)3)

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
    int tempCounterScore;
    
    // Array containing all the Questions [ Flags image names ] from directory
    NSArray * directoryContents;
    
    // Correct answer / image / flage name for this this Question ( on every next move this will change )
    NSString *correctCountry;




}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    
    // This class is ahred by two View - so if score is there then we need to take care of Score screen
    
    if(self.score)
    {
       // self.ResultLable.text = [@(self.score) stringValue];
        [self showReslutWithCounter];
    }
    else // if not we start the game
    {

        directoryContents =  [AssetFilesUtils getAllassetFiles];
        
        [self resetAllButtons];
        [self doNextMove];
        [self startGame];
        
        self.score = 0; // initalize game with this score - e.g 0 ?
        self.currentScore.text = [@(self.score) stringValue];
    }

}

-(void)viewDidAppear:(BOOL)animated
{

}
// ---- START : Reslut Screen

// Start showing Reslut with counter up to reslut score
-(void)showReslutWithCounter
{
    
     [NSTimer scheduledTimerWithTimeInterval:.2 // fire every .09 seconds
                                     target:self
                                   selector:@selector(updateReslutLable:)
                                   userInfo:nil
                                    repeats:YES];
    tempCounterScore = 0;
    
    [self.flagReslutsImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.flagReslutsImageView.layer setBorderWidth: 0.5];
}

-(void)updateReslutLable:(NSTimer*)intimer
{
    NSLog(@"Flags %@",self.CorrectImages);
    if(tempCounterScore < self.score)
    {
        NSString *imageName = [AssetFilesUtils CountryNametoFileName:self.CorrectImages[tempCounterScore]];
        NSLog(@"File looking for %@",imageName);
        self.flagReslutsImageView.image = [UIImage imageNamed:imageName];
        tempCounterScore++; // increment uptill we reach score
        self.ResultLable.text = [@(tempCounterScore) stringValue];

    }
    else {
        [intimer invalidate]; // Stop the counter
        intimer = nil;

    }
    
    
}
// ---- END : Reslut Screeen

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    }
}


//- (IBAction)gameOver:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"showResults" sender:nil];//IndexPath as sender
//}
- (IBAction)reStart:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"reStartGame" sender:nil];//IndexPath as sender
}

- (IBAction)goHome:(UIButton *)sender {
    //goGameHome
    [self performSegueWithIdentifier:@"goGameHome" sender:nil];//IndexPath as sender
}

// ======= Game Controlles

#pragma mark [Game Control]
-(void)startGame
{

    counterValue = GAME_TIME; // We start counter with max and then go down every second
    correctAnswers = -1;
    correctAnswerOnFirstTry = TRUE;
    [self updateAnswerLabl];
    self.CorrectImages = [[NSMutableArray alloc] init];
    gamesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateLabel:)
                                           userInfo:nil
                                            repeats:YES ];

    
    [self.questionImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.questionImage.layer setBorderWidth: 0.5];
}

-(void)resetAllButtons
{
    [self setButtonToDefalut:self.anser1Button1];
    [self setButtonToDefalut:self.anser2Button2];
    [self setButtonToDefalut:self.anser3Button3];
    [self setButtonToDefalut:self.ansser4Button4];
    
    self.anser1Button1.layer.borderWidth=0.2f;
    self.anser1Button1.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.anser2Button2.layer.borderWidth=0.2f;
    self.anser2Button2.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.anser3Button3.layer.borderWidth=0.2f;
    self.anser3Button3.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.ansser4Button4.layer.borderWidth=0.2f;
    self.ansser4Button4.layer.borderColor=[[UIColor blackColor] CGColor];
}

-(void)setButtonToDefalut:(UIButton*)button
{
    button.backgroundColor = [UIColor grayColor];
}


// Game timer Stuff
- (void)updateLabel:(id)sender{
    if(counterValue <= GAME_OVER_AT){ // We reached 0
        [self killTimer];
        [self performSegueWithIdentifier:@"showResults" sender:nil];//This will chagne the screen for user so they can't keep laying
    }
    self.timeLeft.text = [NSString stringWithFormat:@"%d", counterValue];
    counterValue--;
    
}

- (void)killTimer{
    if(gamesTimer){
        [gamesTimer invalidate];
        gamesTimer = nil;
    }
}

#pragma mark [ Game moves ]
-(void)doNextMove
{
    if(counterValue >= 0){
        correctAnswerOnFirstTry = TRUE;
        NSArray *temImgId = [self getEightRandomLessThan:[@(directoryContents.count) intValue]];
        NSArray *temImg_Id = [self getEightRandomLessThan:4];
        correctCountry = directoryContents[[temImgId[[temImg_Id[0] integerValue]] integerValue]];
        correctCountry = [AssetFilesUtils formatCountryName:correctCountry];
        
        //during game if we find same question again then try again and get new question
        if([self.CorrectImages containsObject:correctCountry]){
            [self doNextMove];
        }else{
        
        NSLog(@"Correct country %@",correctCountry);
        

        self.questionImage.image = [UIImage imageNamed:directoryContents[[temImgId[[temImg_Id[0] intValue]] intValue] ]];

        
        
        [self.anser1Button1 setTitle:[AssetFilesUtils formatCountryName:directoryContents[[temImgId[1] intValue]]] forState:UIControlStateNormal];
        
        [self.anser2Button2 setTitle:[AssetFilesUtils formatCountryName:directoryContents[[temImgId[2] intValue]]] forState:UIControlStateNormal];
        
        [self.anser3Button3 setTitle:[AssetFilesUtils formatCountryName:directoryContents[[temImgId[0] intValue]]] forState:UIControlStateNormal];
        
        [self.ansser4Button4 setTitle:[AssetFilesUtils formatCountryName:directoryContents[[temImgId[3] intValue]]] forState:UIControlStateNormal];
        
        [self resetAllButtons];
        }
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
    if(counterValue >=0){
        if([self CheckAnser:button]){
            button.backgroundColor = [UIColor greenColor];
            

            

            // [self next:sender];
            [self performSelector:@selector(doNextMove) withObject:nil afterDelay:.5];
            [self bump:button];
            
        }
        else {
            button.backgroundColor = [UIColor redColor];
            correctAnswerOnFirstTry = FALSE;
        }
    }
    
    
}

- (IBAction)bump:(UIButton *)button {
    
    if(correctAnswerOnFirstTry){
        if (counterValue+GAME_TIME_BUMP <= GAME_TIME ) {
            counterValue = counterValue + GAME_TIME_BUMP;
        }
        
        NSString *correctImage = button.titleLabel.text;
        [self.CorrectImages addObject:correctImage];
        // increment score / answer count
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
    else
        return NO;
    
}
-(void)updateAnswerLabl
{
    correctAnswers++;
    self.currentScore.text = [@(correctAnswers) stringValue];
}


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


@end
