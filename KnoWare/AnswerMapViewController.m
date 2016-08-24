//
//  MapViewController2.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/17/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "AnswerMapViewController.h"
#import "AFNetworking.h"
#import "HexColors.h"
#import "SMCalloutView.h"
#import "CustomIOSAlertView.h"
#import "SelectedQuerySingleton.h"
@import GoogleMaps;
@import CoreLocation;

static const CGFloat CalloutYOffset = 50.0f;

@interface AnswerMapViewController () <GMSMapViewDelegate>{
    SelectedQuerySingleton *selectedQuery;
}
@property (nonatomic,strong) NSArray *queryAnswersArray;
@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;
@end

@implementation AnswerMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedQuery = [SelectedQuerySingleton sharedManager];
   
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.hidesBackButton = YES;
    
    self.markerArray = [[NSMutableArray alloc] init];
    
    self.calloutView = [[SMCalloutView alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    self.calloutView.rightAccessoryView = button;
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = selectedQuery.surveyID;
    
    self.questionLabel.text = selectedQuery.question;
    
    [self loadAnswers];
}

-(void)viewDidAppear:(BOOL)animated{
    selectedQuery = [SelectedQuerySingleton sharedManager];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.hidesBackButton = YES;
    
    self.markerArray = [[NSMutableArray alloc] init];
    
    self.calloutView = [[SMCalloutView alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    self.calloutView.rightAccessoryView = button;
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self loadAnswers];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadAnswers{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",@"http://agile.bgsu.edu/KnoWare/iOS/mapService.php?id=",selectedQuery.surveyID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryAnswersArray = responseObject;
        [self addPins];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
}

-(void)addPins{
    for (int i = 0; i < self.queryAnswersArray.count; i++) {
        NSString *latitude = [[NSString alloc] initWithFormat:@"%@",[[self.queryAnswersArray objectAtIndex:i] objectForKey:@"latitude"]];
        NSString *longitude = [[NSString alloc] initWithFormat:@"%@",[[self.queryAnswersArray objectAtIndex:i] objectForKey:@"longitude"]];
        NSString *response = [[NSString alloc] initWithFormat:@"%@",[[self.queryAnswersArray objectAtIndex:i] objectForKey:@"response"]];
        NSString *hexColor = [[NSString alloc] initWithFormat:@"#%@",[[self.queryAnswersArray objectAtIndex:i] objectForKey:@"hexcolor"]];
        NSString *imageName = [[NSString alloc] initWithFormat:@"%@",[[self.queryAnswersArray objectAtIndex:i] objectForKey:@"image_name"]];
        
        CLLocationCoordinate2D posistion = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = posistion;
        marker.opacity = 0.5;
        marker.snippet = response;
        marker.icon = [GMSMarker markerImageWithColor:[UIColor hx_colorWithHexString:hexColor]];
        marker.userData = imageName;
        marker.map = self.mapView;
        [self.markerArray addObject:marker];
        
    }
    
    //fit window to markers
    if([self.markerArray count] > 0){
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker = [self.markerArray objectAtIndex:0];
        CLLocationCoordinate2D myLocation = marker.position;
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
        
        for (int i = 1; i < [self.markerArray count]; i++) {
            marker = [self.markerArray objectAtIndex:i];
            bounds = [bounds includingCoordinate:marker.position];
        }
        [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:25.0f]];
    }
    self.mapView.delegate = self;
    
}

#pragma mark - GMSMapViewDelegate
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    
    self.calloutView.title = marker.snippet;
    
    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
    
    self.calloutView.hidden = NO;
    
    CGRect calloutRect = CGRectZero;
    calloutRect.origin = point;
    calloutRect.size = CGSizeZero;
    
    [self.calloutView presentCalloutFromRect:calloutRect
                                      inView:mapView
                           constrainedToView:mapView
                                    animated:YES];
    
    return self.emptyCalloutView;
}

- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position {
    /* move callout with map drag */
    if (pMapView.selectedMarker != nil && !self.calloutView.hidden) {
        CLLocationCoordinate2D anchor = [pMapView.selectedMarker position];
        
        CGPoint arrowPt = self.calloutView.backgroundView.arrowPoint;
        
        CGPoint pt = [pMapView.projection pointForCoordinate:anchor];
        pt.x -= arrowPt.x;
        pt.y -= arrowPt.y + CalloutYOffset;
        
        self.calloutView.frame = (CGRect) {.origin = pt, .size = self.calloutView.frame.size };
    } else {
        self.calloutView.hidden = YES;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.calloutView.hidden = YES;
}

- (void)calloutAccessoryButtonTapped:(id)sender {
    if (self.mapView.selectedMarker) {
        //nslog(@"Clicked");
        GMSMarker *marker = self.mapView.selectedMarker;
        
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        
        [alertView setContainerView:[self createDemoView:marker.userData]];
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", nil]];
        //[alertView setDelegate:self];
        
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            //nslog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
            [alertView close];
        }];
        
        [alertView setUseMotionEffects:true];
        
        [alertView show];
        
    }
}

- (UIView *)createDemoView:(NSString*)imageTitle{
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, demoView.bounds.size.width, demoView.bounds.size.height-50)];
    CGRect myFrame = imageView.frame;
    myFrame.origin.x = CGRectGetMidX(demoView.bounds) - CGRectGetMidX(imageView.bounds);
    myFrame.origin.y = 0;
    imageView.frame = myFrame;
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *imageURL = [NSURL URLWithString:@"http://agile.bgsu.edu/KnoWare/uploadFiles/"];
    imageURL = [imageURL URLByAppendingPathComponent:imageTitle];
    
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    [imageView setImage:image];
    [demoView addSubview:imageView];
    
    return demoView;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    [(UINavigationController*)viewController popToRootViewControllerAnimated:YES];
    return YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)homeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"answerMapToHome" sender:self];
}
@end
