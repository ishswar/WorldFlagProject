//
//  DetailViewController.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/13/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "DetailViewController.h"
#import "CommonUtils.h"

#define WIKI_URL @"http://en.wikipedia.org/w/api.php?action=opensearch&search=%@&limit=1&namespace=0&format=json"

@interface DetailViewController ()

@end

@implementation DetailViewController {

    UIWebView* aWebView;
    wikiObject* modelObj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self doMKMapInitialization];
    [self doDelegationStuff];
    [self guiElementsintialization];
    


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doMKMapInitialization
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.mapView.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.mapView.showsUserLocation = YES;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleGesture:)];
    lpgr.minimumPressDuration = .8;  //user must press for 2 seconds
    [self.mainView addGestureRecognizer:lpgr];
}

-(void)doDelegationStuff
{
    
    self.infoWebView.delegate = self;
    
    self.navigationItem.title = self.countryLocation;
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.view.frame.size;
}

-(void)guiElementsintialization
{
    [[self.webView layer] setBorderColor:
     [[UIColor colorWithRed:0.459 green:0.82 blue:1 alpha:1] CGColor]];
    [[self.webView layer] setBorderWidth:1.75];
    
    [[self.webView layer] setCornerRadius:5];
    [self.webView setClipsToBounds:YES];
    
    [[self.infoView layer] setBorderColor:
     [[UIColor colorWithRed:0.459 green:0.82 blue:1 alpha:1] CGColor]];
    [[self.infoView layer] setBorderWidth:1.75];
    [[self.infoView layer] setCornerRadius:5];
    
    self.aboutCountryLable.text = [NSString stringWithFormat:@"About %@",self.countryLocation];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES]; // Push scorll view to all the way to top
    [self guiElementsintialization];
    // Start loading Wiki data
    [self getWikiData:self.countryLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES]; // Push scorll view to all the way to top
    
    // If info window is open and user taps outside the window - we need to close info Window 
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoClose:)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    
    // Find a geo location of Country and show it on Apple map
    NSString *location =  self.countryLocation; //[NSString stringWithFormat:@",%@",self.countryLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         
                         MKPlacemark *placemark ;
                         
                         
                         // App map is showing "Georgia US state" we need Georgia country - so let's give it's cordinates for it ..
                         if ([self.countryLocation rangeOfString:@"Georgia" options:NSCaseInsensitiveSearch].location != NSNotFound)
                         {
                         CLLocationDegrees lat = 42.315407;
                         CLLocationDegrees longi = 43.356892;
                         CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, longi);
                          placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
                         }else // All other get's location from geocodeAddressString
                         {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                          placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         }
                         
                         MKCoordinateRegion region = self.mapView.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 1.3; // Zoom in
                         region.span.latitudeDelta /= 1.3;

                         MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                         point.coordinate = placemark.coordinate;
                         point.title = location;
                         
                        
                         [self.mapView setRegion:region animated:YES];
                         [self.mapView addAnnotation:point];
                         
                         

                     }
                 }
     ];
    
    // Show small image of Flag on Map ( PIP )
    NSString *imageName = [self CountryNametoFileName:self.countryLocation];
    
    UIImage *image = [UIImage imageNamed:imageName];
    self.insetImageView.image = image;
    self.insetImageView.layer.masksToBounds = YES;
    self.insetImageView.layer.cornerRadius = 2.0;
    self.insetImageView.layer.borderWidth = 1.0;
    self.insetImageView.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D location =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    
    CLLocation *loc = [[ CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [self reverseGeocode:loc];
    
    
    
}

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            //NSString* locationadd = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
           MKPlacemark* mkplacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
            
            NSLog(@"Country %@",mkplacemark.country);
            
            self.countryLocation = mkplacemark.country;
            
            [self viewWillAppear:TRUE];
            
        }
    }];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
  //  NSLog(@"view %@",view);
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //Here
    [mapView selectAnnotation:[[mapView annotations] lastObject] animated:YES];
}

// Once map loades add a annotation on Mapp for Country Name and "i" icon ( accessory icon )
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
  //  MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc]     initWithAnnotation:annotation reuseIdentifier:@"pinLocation"];
    
    static NSString *viewIdentifier = @"annotationView";
    MKPinAnnotationView *newAnnotation = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:viewIdentifier];
    if (newAnnotation == nil) {
        newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewIdentifier];
    }
    
    newAnnotation.canShowCallout = YES;
    newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    NSString *imageName = [self CountryNametoFileName:annotation.title];//[NSString stringWithFormat:@"%@.png",annotation.title];
    
    NSLog(@"Loading ............... %@",imageName);
    
    UIImage *image = [UIImage imageNamed:imageName];

    newAnnotation.image = [CommonUtils imageWithImage:image scaledToSize:CGSizeMake(25, 20)];
    
    //odd
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:NO];

    
    
    return newAnnotation;
}

//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    id<MKAnnotation> myAnnotation = [mapView.annotations objectAtIndex:0];
//    [mapView selectAnnotation:myAnnotation animated:YES];
//}

// On map if user clicks "i" accessory button let's pop-up Wiki page for more info ..
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self initUIWebView];
}

//************* START : info pop-up methods

//- (void) hideinfo {
//    if(!self.infoView.hidden){
//    self.infoView.hidden = YES;
//    [self.mainView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
//    }
//   
//}

- (IBAction)goToinfoWebView:(UIButton *)sender {
    [self initUIWebView];
}


// Open UIWebView and go to Wiki page
- (void) initUIWebView
{


    self.infoWebView.autoresizesSubviews = YES;
    self.infoWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);

    NSString *urlAddress =  modelObj.url; // go to full Wiki page
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.infoWebView loadRequest:requestObj];
    self.webViewBackButton.hidden = YES;
    self.webViewForwardButton.hidden = YES;
    

    
    // Un hide the web view .
    self.infoView.hidden = NO;
    self.infoView.alpha = 0.0;
    [UIView animateWithDuration:.6 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        self.infoView.alpha = 1.0;
    } completion:^(BOOL finished) {
        // set background view as darken
        [self.mainView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
        self.webView.hidden = YES;
        self.insetImageView.hidden = YES;
        self.mapView.hidden = YES;
    }];
    


    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
    [self.infoWebView loadHTMLString:[NSString stringWithFormat:@" error => %@ ", [error localizedDescription]] baseURL:nil];
}

// hide the webview
- (IBAction)infoClose:(UIButton *)sender {
    
    if(!self.infoView.hidden){
        self.infoView.hidden = YES;
        [self.mainView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
        self.webView.hidden = NO;
        self.insetImageView.hidden = NO;
        self.mapView.hidden = NO;
    }
}

// Webview browser back button
- (IBAction)webViewBackPressed:(UIButton *)sender {
    [self.infoWebView goBack];
}

// Webview browser forward button
- (IBAction)webViewForwardPressed:(UIButton *)sender {
    [self.infoWebView goForward];
}

// Open wiki link in safari
- (IBAction)openInSafariPressed:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:modelObj.url]];
}

// Delegate methods for Webview to enable forward and backward buttons
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Enable or disable back
    [self.webViewBackButton setEnabled:[self.infoWebView canGoBack]];
    if(self.infoWebView.canGoBack){
        self.webViewBackButton.hidden = NO;
    }
    
    // Enable or disable forward

    [self.webViewForwardButton setEnabled:[self.infoWebView canGoForward]];
    if(self.infoWebView.canGoForward){
        self.webViewForwardButton.hidden = NO;
    }
    
}
//************* END : info pop-up methods



// Healper method - get a original file name from Country name
-(NSString*)CountryNametoFileName:(NSString*)input
{
    return [[input stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingString:@".png"];
 
}

// Take a input string and search it on Wiki pedia
- (void)getWikiData:(NSString*)country
{
    NSString *urlAsString = [NSString stringWithFormat:WIKI_URL, country]; // Add country as "&search=country" - search parameter
    // More info on Wiki Search / API : http://www.mediawiki.org/wiki/API:Opensearch
    
    // URL Encode the String - ( => %28 or space => %20 etc
    NSString *encodedText = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // Build uRL
    NSURL *url = [[NSURL alloc] initWithString:encodedText];
    
    
    [self.webView loadHTMLString:[NSString stringWithFormat:@" loading => %@ ", @"Data..."] baseURL:nil];

    //Send a asynch request and wait for reply ( non blocking )
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
 
            [self.webView loadHTMLString:[NSString stringWithFormat:@" error => %@ ", [error localizedDescription]] baseURL:nil];
        } else {
            modelObj =[self modelObjFromJSON:data error:nil];
            modelObj.objDescription = [NSString stringWithFormat:@"<p><i>%@</i></p>",modelObj.objDescription];
            [self.webView loadHTMLString:modelObj.objDescription baseURL:nil];
        }
    }];
}

/*
 * Take NSData as input , parse that NSData as JSON object
 * Reply from wiki is in Array format not in Disctionary 
 
 Sample : URG : GET : http://en.wikipedia.org/w/api.php?action=opensearch&search=France&limit=1&namespace=0&format=json
 
 Reply
 [
 "France",
 [
 "France"
 ],
 [
 "France (/fr\u00e6ns/; French: [f\u0281\u0251\u0303s] ( )), officially the French Republic (French: R\u00e9publique fran\u00e7aise [\u0281epyblik f\u0281\u0251\u0303s\u025bz]), is a unitary sovereign state comprising territory in western Europe and several overseas regions and territories."
 ],
 [
 "http://en.wikipedia.org/wiki/France"
 ]
 ]
 
 */
-(wikiObject *)modelObjFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:NSJSONReadingMutableContainers error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    wikiObject *wikiObj = [[wikiObject alloc]init];
    
    
    int i =0;
    for (NSString* key in parsedObject) {
        
        NSLog(@"Parsed obj %@",key);
        NSString* currentvalue = [[NSString alloc] init];
        
        if([key isKindOfClass:[NSString class]])
        {
            currentvalue = key; // if it is String then we are done
        }else if([key isKindOfClass:[NSArray class]]){ // if it is Array then read the first element out of it .
            NSArray* newSt = (NSArray*)key;
            
            
            if(newSt.count > 0){
                currentvalue = newSt[0];
            }
        }
        
          switch (i) {
            case 1:
                wikiObj.name = currentvalue; // obj Name ( Fixed by Wiki )
                break;
            case 2:
                wikiObj.objDescription = currentvalue; // obj discription
                break;
            case 3:
                wikiObj.url = currentvalue; // obj Wiki URL
                break;
            default:
                break;
        }

        i++;
    }
    

    return wikiObj;
}




@end
