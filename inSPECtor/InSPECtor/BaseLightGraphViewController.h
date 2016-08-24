//
//  BaseLightGraphViewController.h
//  inSPECtor
//
//  Created by Jeremy Storer on 10/11/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/ios/CorePlot.h>

@interface BaseLightGraphViewController : UIViewController <CPTPlotDataSource,CPTScatterPlotDelegate,CPTPlotDelegate>
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (weak, nonatomic) IBOutlet UIImageView *baselightImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
