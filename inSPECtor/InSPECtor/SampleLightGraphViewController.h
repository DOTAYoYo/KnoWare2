//
//  SampleLightGraphViewController.h
//  inSPECtor
//
//  Created by Jeremy Storer on 10/12/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/ios/CorePlot.h>


@interface SampleLightGraphViewController : UIViewController <CPTPlotDataSource, CPTScatterPlotDelegate,CPTPlotDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *baselightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *samplelightImageView;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *intensityHostView;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *absorbanceHostView;

@end
