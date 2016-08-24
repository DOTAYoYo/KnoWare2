//
//  AnalysisSecondaryViewController.h
//  InSPECtor
//
//  Created by Jeremy Storer on 4/30/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/ios/CorePlot.h>

@interface AnalysisSecondaryViewController : UIViewController
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic) float result;
@property (nonatomic) double max1,max2,max3,maxLocation1,maxLocation2,maxLocation3;
@property (nonatomic) double nitrateppm;
@property (strong, nonatomic) NSNumber       *peakSeperationValue;
@property (strong, nonatomic) NSMutableArray *maxPeakValues;
@property (strong, nonatomic) NSMutableArray *maxPeakLocation;
@property (strong, nonatomic) NSMutableArray *maxLocationForGraph;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)calculatePressed:(id)sender;
@end
