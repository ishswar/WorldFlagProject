//
//  DetailViewController.h
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/13/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "modelObject.h"

@import CoreLocation;

@interface DetailViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIWebViewDelegate>


- (modelObject *)modelObjFromJSON:(NSData *)objectNotation error:(NSError **)error;

@property (strong, nonatomic) IBOutlet UIView *mainView;

//@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSString* countryLocation;


//@property (strong, nonatomic) IBOutlet UIWebView *webView;
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
//webView
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *aboutCountryLable;

@property (strong, nonatomic) IBOutlet UIImageView *insetImageView;

// info view 
- (IBAction)goToinfoWebView:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIWebView *infoWebView;
@property (strong, nonatomic) IBOutlet UIButton *webViewBackButton;
@property (strong, nonatomic) IBOutlet UIButton *webViewForwardButton;

- (IBAction)infoClose:(UIButton *)sender;
- (IBAction)webViewBackPressed:(UIButton *)sender;
- (IBAction)webViewForwardPressed:(UIButton *)sender;
- (IBAction)openInSafariPressed:(UIButton *)sender;

// Horizontal view



@end
