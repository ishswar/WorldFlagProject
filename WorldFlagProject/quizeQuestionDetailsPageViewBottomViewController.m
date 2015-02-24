//
//  quizeQuestionDetailsPageViewBottomViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/22/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "quizeQuestionDetailsPageViewBottomViewController.h"
#import "AssetFilesUtils.h"


@interface quizeQuestionDetailsPageViewBottomViewController ()

@end

@implementation quizeQuestionDetailsPageViewBottomViewController {
    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    NSLog(@"Quize type %d - %d - %d : ",self.quizeType ,TexttoFlag, FlagtoText);
    if(self.questiontoShow != nil)
    {
        self.quizeQuestionNumber.text = [@(self.pageIndex) stringValue];
        self.quizeQuestionDuration.text = [self formattedStringForDuration:self.questiontoShow.duration];
        
        if(self.quizeType == TexttoFlag)
        {
            self.quizeQuestionImage.hidden = NO;
            self.quizeQuestionImage.image = [UIImage imageNamed:[AssetFilesUtils CountryNametoFileName:self.questiontoShow.question]];
            self.quizeQuestionImage.alpha = 0.3;
            self.quizeQuestionTextHelperLable.hidden = YES;
            self.quizeQuestionTextLabel.hidden = NO;
            self.quizeQuestionTextLabel.text = self.questiontoShow.question;
        }
        else
        {
            self.quizeQuestionTextLabel.hidden = YES;
            self.quizeQuestionImage.hidden = NO;
            self.quizeQuestionImage.image = [UIImage imageNamed:[AssetFilesUtils CountryNametoFileName:self.questiontoShow.question]];
            self.quizeQuestionTextHelperLable.text = self.questiontoShow.question;
        }
        [self.quizeQuestionOption1Button setTitle:self.questiontoShow.question forState:UIControlStateNormal];
        [self.quizeQuestionOption1Button setBackgroundColor:[UIColor greenColor]];
        
        
        int x = 1;
        for(NSString *option in self.questiontoShow.arrayofOptions)
        {
            switch (x) {
                case 1:
                   // [self.quizeQuestionOption1Button setTitle:option forState:UIControlStateNormal];
                    [self prePareButton:self.quizeQuestionOption1Button inOption:option];
                    [self.quizeQuestionOption1Button setBackgroundColor:[self getColorForButton:option]];
                    x++;
                    break;
                case 2:
                    //[self.quizeQuestionOption2Button setTitle:option forState:UIControlStateNormal];
                    [self prePareButton:self.quizeQuestionOption2Button inOption:option];
                    [self.quizeQuestionOption2Button setBackgroundColor:[self getColorForButton:option]];
                    x++;
                    break;
                case 3:
                    //[self.quizeQuestionOption3Button setTitle:option forState:UIControlStateNormal];
                    [self prePareButton:self.quizeQuestionOption3Button inOption:option];
                    [self.quizeQuestionOption3Button setBackgroundColor:[self getColorForButton:option]];
                    x++;
                    break;
                case 4:
                    //[self.quizeQuestionOption4Button setTitle:option forState:UIControlStateNormal];
                    [self prePareButton:self.quizeQuestionOption4Button inOption:option];
                    [self.quizeQuestionOption4Button setBackgroundColor:[self getColorForButton:option]];
                    x++;
                    break;
                default:
                    break;
            }
            
        }
        
    }
    


}

-(UIColor*)getColorForButton:(NSString*)option
{

    if([option isEqualToString:self.questiontoShow.question] && self.questiontoShow.answertime !=nil)
        return [UIColor greenColor];
    else if([self.questiontoShow.arrayofWrrongAnswers containsObject:option])
        return [UIColor redColor];
    else
        return  [UIColor lightGrayColor];
    
}

-(void)prePareButton:(UIButton*)button inOption:(NSString*)option
{
    if(self.quizeType == FlagtoText)
    {
    [button setTitle:option forState:UIControlStateNormal];
    }else
    {
        //self.quizeQuestionImage.image = [UIImage imageNamed:[AssetFilesUtils CountryNametoFileName:self.questiontoShow.question]];
        NSString *imgName = [AssetFilesUtils CountryNametoFileName:option];
        NSLog(@"Image for this country %@",imgName);
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
    
    
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

- (NSString*)formattedStringForDuration:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
}
@end
