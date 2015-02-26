//
//  SecondViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/12/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "SecondViewController.h"
#import "DetailViewController.h"
#import "AssetFilesUtils.h"
#import "CommonUtils.h"
#import "CommonStuffHeader.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    
    // Raw directory content - list of file names
    NSArray * directoryContents;
    // Array with all 26 alphabests
    NSArray* allAlphabest;
    // Directory with content sorted / removed / filtred
    NSMutableArray *directorymutableContents;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // load data for UITable View ( Same data is used by horizotal scrolling )
    directoryContents = [AssetFilesUtils getAllassetFiles];
    // Array containing Just alphabests
    allAlphabest = [AssetFilesUtils getAlphabetArray];
    
    // Customize the back button for push segue
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    

    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:FONT_STYLE size:18] forKey:NSFontAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    



    
    // Setup ouir horizontal scrolling buttons / sizes / guesters
    [self setupGuestersForHorizontalScrolling];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGuestersForHorizontalScrolling
{
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.horizontalView addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.horizontalView addGestureRecognizer:swiperight];
    
    self.horizontalView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCountryDetails:)];
    
    [self.horizontalShowLable addGestureRecognizer:tapGesture];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return allAlphabest.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    
    directorymutableContents = [directoryContents mutableCopy];
    
    //We need to cutdonw the directory contains and only need files that starts with this letter
    NSString* predicateString =  [NSString stringWithFormat:@"SELF beginswith[c] '%@'",allAlphabest[section]];

    // Do the array filtering
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:predicateString];
    [directorymutableContents filterUsingPredicate:sPredicate];

    // Return array
    return directorymutableContents.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // Alphabet array
    return allAlphabest;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return [allAlphabest[section] uppercaseString];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
 
     directorymutableContents = [directoryContents mutableCopy];
     
     NSString* predicateString =  [NSString stringWithFormat:@"SELF beginswith[c] '%@'",allAlphabest[indexPath.section]];

     NSPredicate *sPredicate = [NSPredicate predicateWithFormat:predicateString];
     [directorymutableContents filterUsingPredicate:sPredicate];
     
     NSString* celltext = [AssetFilesUtils formatCountryName:directorymutableContents[indexPath.row]] ;
     cell.textLabel.text = celltext;
     //cell.detailTextLabel.text = [@(indexPath.row) stringValue];
     
     UIImage *image = [UIImage imageNamed:[AssetFilesUtils CountryNametoFileName:celltext]];
     cell.imageView.image = [CommonUtils imageWithImage:image scaledToSize:CGSizeMake(65, 40)];

     return cell;
 }
 

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     // Go to Image view ( MAP + Wiki data )
     if([segue.identifier isEqualToString:@"showCountryDetail"])
     {
         if([segue.destinationViewController isKindOfClass:[DetailViewController class]])
         {
             if([sender isKindOfClass:[NSIndexPath class]])
             {
                 NSIndexPath *index = sender;
                 DetailViewController *dv = segue.destinationViewController;
                 //  NSIndexPath *path = [self.tableView indexPathForSelectedRow];
                 UITableViewCell *swipedCell  = [self.tableView cellForRowAtIndexPath:index];
                 dv.countryLocation = swipedCell.textLabel.text;
             }
             
         }
     }
     
 }

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showCountryDetail" sender:indexPath];//IndexPath as sender
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self doFilmStrip:indexPath];
}



// ---- START : Horizontal view [ We could use Page view here ] 

// UINavigation bar button Togle between Horizontal or UITable View

- (IBAction)goHorizontal:(UIBarButtonItem *)sender {
    
    [self doFilmStrip:nil];
    
}

// do togal between Horizontal view

-(void)doFilmStrip:(NSIndexPath*)index
{
    //NSLog(@" self.horizontalView.hidden : %@",[@(self.horizontalView.hidden) stringValue]);
    if(self.horizontalView.hidden)
    {
        self.tableView.hidden = YES;
        self.horizontalView.hidden = NO;
        NSString *imgname;
        NSString *countryName;
        
        if(index == nil)
        {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        if(path != nil)
        {
            UITableViewCell *swipedCell  = [self.tableView cellForRowAtIndexPath:path];
            imgname = [AssetFilesUtils CountryNametoFileName:swipedCell.textLabel.text];
            countryName = swipedCell.textLabel.text;
        }
        else
        {
            imgname = directoryContents[0];
            countryName = [AssetFilesUtils formatCountryName:imgname];
            NSIndexPath *newpath = [ NSIndexPath indexPathForItem:0 inSection:0];
            [self.tableView selectRowAtIndexPath:newpath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        }
        else
        {
            //NSLog(@"Index is : %ld",(long)index.row);
            UITableViewCell *swipedCell  = [self.tableView cellForRowAtIndexPath:index];
            imgname = [AssetFilesUtils CountryNametoFileName:swipedCell.textLabel.text];
            countryName = swipedCell.textLabel.text;

        }
        
        
        self.horizontalCountryFlagImage.image = [UIImage imageNamed:imgname];
        self.horizontalCountryName.text = countryName;
        
        self.horizontalCountryFlagImage.layer.masksToBounds = YES;
        self.horizontalCountryFlagImage.layer.cornerRadius = 5.0;
        self.horizontalCountryFlagImage.layer.borderWidth = 0.5;
        self.horizontalCountryFlagImage.layer.borderColor = [[UIColor clearColor] CGColor];
        
        self.navigationItem.leftBarButtonItem.title = @"List";
    }else
    {
        self.horizontalView.hidden = YES;
        self.tableView.hidden = NO;
        self.navigationItem.leftBarButtonItem.title = @"FlagStrip";
    }
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    
    NSIndexPath *newpath;
    int nextSection;
   
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
     NSInteger totalRow = [self.tableView numberOfRowsInSection:path.section];
    
    long newpathrow = path.row +1;
    NSInteger newRow = [@(newpathrow) integerValue];
    if(newRow == totalRow ){
        if(path.section == ([self.tableView numberOfSections]-1))
        {
            nextSection = 0;
        }
        else
            nextSection = [@(path.section+1) intValue];
        
        // let's find out total rows / cells in next ( previous section )
        NSInteger totalRowinNewSection = [self.tableView numberOfRowsInSection:nextSection];
        
        // Some section has no Rows then we keep looking for previous section that has some rows
        while (totalRowinNewSection == 0)
        {
            nextSection =[@(nextSection) intValue]+1;
            totalRowinNewSection = [self.tableView numberOfRowsInSection:nextSection];
        }
        
        newpath = [ NSIndexPath indexPathForItem:0 inSection:nextSection];
    }
    else
    {
        newpath = [ NSIndexPath indexPathForItem:newRow inSection:path.section];
    }

    //Show set this cell / row
    [self showSetNextCell:newpath];
    
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    
    NSIndexPath *newpath;
    int previousSection;
    
    // Let's findout what Row / Cell was selected in UITable view
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    

    
    //let's pick one cell before one we are
    NSInteger newRow = [@(path.row -1) integerValue];
    if(newRow == -1 ){ // we we ended up with -1 that meas we were at first row of section - that means we need to jump to last cell of previous cell
        
        // This logic could be optimized ***
        // if we are are at first Row/cell in first section then we need to jump to all the way back to bottom of list / film strip
        if(path.section == 0 && path.row ==0)
            previousSection = [@([self.tableView numberOfSections]) intValue]-1;
        else if(path.row == 0) // if are at first row of any section and going back in film strip then we need to jimp to previous section
            previousSection = [@(path.section-1) intValue];
        else // defalut
            previousSection = [@(path.section) intValue];
        
        // let's find out total rows / cells in next ( previous section )
        NSInteger totalRow = [self.tableView numberOfRowsInSection:previousSection];
        
        // Some section has no Rows then we keep looking for previous section that has some rows
        while (totalRow == 0)
        {
            previousSection =[@(previousSection) intValue]-1;
            totalRow = [self.tableView numberOfRowsInSection:previousSection];
        }
        
        newpath = [ NSIndexPath indexPathForItem:totalRow-1 inSection:previousSection];
    }
    else
    {
        newpath = [ NSIndexPath indexPathForItem:newRow inSection:path.section];
    }
    
    //Show set this cell / row
    [self showSetNextCell:newpath];
}

// Read next cell / Row and show image of that and title
-(void)showSetNextCell:(NSIndexPath*)nextPath
{
    NSString *imgname; //  image
    NSString *countryName; // cell title
    
    UITableViewCell *nextCell = [self tableView:self.tableView cellForRowAtIndexPath:nextPath];
    
    // As we move in film strip update UI Table view in background - so when we switch to list / UITable view we see same selected row
    [self.tableView selectRowAtIndexPath:nextPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    // from cell title we get image name
    imgname = [AssetFilesUtils CountryNametoFileName:nextCell.textLabel.text];
    countryName = nextCell.textLabel.text; // cell title
    
    // Set horizontal view image and lable
    self.horizontalCountryFlagImage.image = [UIImage imageNamed:imgname];
    self.horizontalCountryName.text = countryName;
}

// Horizontal view - lable does not have IBAction - so we added lable user interaction ebaled
// Listen on gesture and go to Country detail view
- (void) showCountryDetails: (UIGestureRecognizer *) gesture {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    [self performSegueWithIdentifier:@"showCountryDetail" sender:path];//IndexPath as sender
}

// Horizontal info button - does same as above
- (IBAction)horizontalShowDetail:(UIButton *)sender {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    [self performSegueWithIdentifier:@"showCountryDetail" sender:path];//IndexPath as sender
}

// ------ END : Horizontal View

@end
