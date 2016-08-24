//
//  RGBViewController.h
//  InSPECtor
//
//  Created by Jeremy Storer on 3/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/ios/CorePlot.h>

@interface RGBViewController : UIViewController <CPTPlotDataSource,CPTScatterPlotDelegate,CPTPlotDelegate>
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (weak, nonatomic) IBOutlet UIImageView *baselightImage;

@end
