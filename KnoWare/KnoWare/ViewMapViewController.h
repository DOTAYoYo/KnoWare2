//
//  ViewViewController.h
//  KnoWare
//
//  Created by Jeremy Storer on 2/14/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;

@interface ViewMapViewController : UIViewController
@property (nonatomic,strong) NSString *surveyID;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) NSMutableArray *markerArray;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

- (IBAction)homeButtonPressed:(id)sender;

- (IBAction)actionButtonPressed:(id)sender;
@end
