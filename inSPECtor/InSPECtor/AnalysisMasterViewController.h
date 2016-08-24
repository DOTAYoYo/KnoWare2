//
//  AnalysisMasterViewController.h
//  inSPECtor
//
//  Created by Jeremy Storer on 10/13/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"
#import <CorePlot/ios/CorePlot.h>

@interface AnalysisMasterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *knowareButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *csvButton;
@property (weak, nonatomic) IBOutlet UITextField *chemicalPicker;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic) DownPicker *picker;
@property (nonatomic) float result;
@property (nonatomic) double max1,max2,max3,maxLocation1,maxLocation2,maxLocation3;
@property (nonatomic) double nitrateppm;

@property (strong, nonatomic) NSNumber       *peakSeperationValue;
@property (strong, nonatomic) NSMutableArray *maxPeakValues;
@property (strong, nonatomic) NSMutableArray *maxPeakLocation;
@property (strong, nonatomic) NSMutableArray *maxLocationForGraph;

- (IBAction)calculateButtonPressed:(id)sender;
- (IBAction)exportCSVButtonPressed:(id)sender;
- (IBAction)knowareButtonPressed:(id)sender;

@end
