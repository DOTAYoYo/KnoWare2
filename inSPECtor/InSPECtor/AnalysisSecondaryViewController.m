//
//  AnalysisSecondaryViewController.m
//  InSPECtor
//
//  Created by Jeremy Storer on 4/30/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "AnalysisSecondaryViewController.h"
#import "Singleton.h"

@interface AnalysisSecondaryViewController ()

@end

@implementation AnalysisSecondaryViewController

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    //  NSLog(@"count: %lu",(unsigned long)[self.intensityArray count]);
    Singleton *singleton = [Singleton sharedManager];
    if([[plot identifier] isEqual:@"absorbancePlot"])
        return [singleton.locationArray count];
    if([[plot identifier] isEqual:@"absorbanceSmoothedPlot"])
        return [singleton.locationArray count];
    else
        return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
    //  NSLog(@"number flor plot");
    Singleton *singleton = [Singleton sharedManager];
    if([[plot identifier] isEqual:@"absorbancePlot"]){
        if(fieldEnum == CPTScatterPlotFieldX){
            return [singleton.locationArray objectAtIndex:idx];
        }
        else{
            return [singleton.smoothedAbsorbance objectAtIndex:idx];
        }
    }
    else
        return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Singleton *singleton = [Singleton sharedManager];
    
    self.maxPeakLocation     = [[NSMutableArray alloc] init];
    self.maxPeakValues       = [[NSMutableArray alloc] init];
    self.maxLocationForGraph = [[NSMutableArray alloc] init];
    self.peakSeperationValue = [[NSNumber alloc] init];
    self.peakSeperationValue = [NSNumber numberWithInt:20];
    
    self.max1 = 0;         self.max2 = 0;         self.max3 = 0;
    self.maxLocation1 = 0; self.maxLocation2 = 0; self.maxLocation3 = 0;
    
    for(int i = 50; i < 400; i++){
        //if there is a peak
        if([singleton.smoothedAbsorbance[i] floatValue] > self.max1){
            self.max1 = [singleton.smoothedAbsorbance[i] floatValue];
            self.maxLocation1 = i;
        }
    }
    
    for (int i = 775; i <= 1100; i++) {
        if([singleton.smoothedAbsorbance[i] floatValue] > self.max2){
            self.max2 = [singleton.smoothedAbsorbance[i] floatValue];
            self.maxLocation2 = i;
        }
    }
    
    [self.maxLocationForGraph addObject:[NSNumber numberWithDouble:self.maxLocation1]];
    [self.maxLocationForGraph addObject:[NSNumber numberWithDouble:self.maxLocation2]];
    
    double ratio = self.max2/self.max1;
    double nitrate = roundf((ratio - 0.086) / 0.0527);
    if (nitrate < 2) {
        self.resultLabel.text = @"Your data indicate a nitrate concentration of less than 2 ppm";
    }else{
        self.resultLabel.text = [NSString stringWithFormat:@"Your data indicate a %@ concentration between %.f and %.f ppm",singleton.selectedTest,nitrate-1,nitrate+1];
    }
    
    [self graphAbsorbance];

}

-(void)graphAbsorbance{
    Singleton *singleton = [Singleton sharedManager];
    self.maxLocationForGraph[1] = [NSNumber numberWithDouble:self.maxLocation2];
    double xAxisStart = 0.0;
    double xAxisLength = [singleton.locationArray count];
    
    double yAxisStart = 0.0;
    //NSNumber *findYMax = [self.absorbanceIntensity valueForKeyPath:@"@max.self"];
    // float yAxisLength = [findYMax floatValue] + 0.05;
    float yAxisLength = 1.0;
    
    CPTXYGraph *absorbanceGraph = [[CPTXYGraph alloc]initWithFrame:self.hostView.bounds];
    
    self.hostView.hostedGraph = absorbanceGraph;
    absorbanceGraph.paddingBottom = 0.0;
    absorbanceGraph.paddingLeft = 0.0;
    absorbanceGraph.paddingTop = 0.0;
    absorbanceGraph.paddingRight = 0.0;
    
    absorbanceGraph.plotAreaFrame.paddingBottom = 25.0;
    absorbanceGraph.plotAreaFrame.paddingLeft = 35.0;
    absorbanceGraph.plotAreaFrame.paddingTop = 5.0;
    absorbanceGraph.plotAreaFrame.paddingRight = 10.0;
    
    //[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blueColor];
    titleStyle.fontName = @"Helvetica-Light";
    titleStyle.fontSize = 14.0f;
    
    NSString *title = @"Absorbance";
    absorbanceGraph.title = title;
    absorbanceGraph.titleTextStyle = titleStyle;
    absorbanceGraph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    absorbanceGraph.titleDisplacement = CGPointMake(10.0f, 20.0f);
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) absorbanceGraph.axisSet;
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    CPTMutableTextStyle *xTextStyle = [CPTMutableTextStyle textStyle];
    xTextStyle.fontName = @"Helvetica-Light";
    xTextStyle.fontSize = 10.0f;
    
    axisSet.xAxis.labelTextStyle = xTextStyle;
    axisSet.yAxis.labelTextStyle = xTextStyle;
    
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0f;
    
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    
    axisSet.xAxis.title = @"Pixel Location";
    axisSet.xAxis.labelTextStyle = xTextStyle;
    
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = nil;
    axisSet.xAxis.majorTickLength = -500.0f;
    axisSet.xAxis.majorTickLocations = [NSSet setWithArray:self.maxLocationForGraph];
    // axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(100.0f);
    axisSet.xAxis.minorTicksPerInterval = 0;
    
    NSUInteger labelLocation = 0;
    NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[self.maxLocationForGraph count]];
    for(NSNumber *tickLocation in self.maxLocationForGraph){
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc]initWithText:[NSString stringWithFormat:@"%@",[self.maxLocationForGraph objectAtIndex:labelLocation++]] textStyle:axisSet.xAxis.labelTextStyle = xTextStyle];
        newLabel.tickLocation = tickLocation;
        newLabel.offset = axisSet.xAxis.labelOffset;
        newLabel.rotation = M_PI / 2;
        [customLabels addObject:newLabel];
    }
    axisSet.xAxis.axisLabels = customLabels;
    
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = nil;
    axisSet.yAxis.majorTickLength = 3.0f;
    axisSet.yAxis.majorIntervalLength = [NSNumber numberWithFloat:0.2];
    axisSet.yAxis.minorTicksPerInterval = 0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)absorbanceGraph.defaultPlotSpace;
    
    CPTPlotRange *xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0] length:[NSNumber numberWithFloat:xAxisLength]];
    //[CPTAnimation animate:plotSpace property:@"xRange" fromPlotRange: plotSpace.xRange toPlotRange:xRange duration:2.5 withDelay:0 animationCurve:CPTAnimationCurveDefault delegate:nil];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:xAxisStart] length:[NSNumber numberWithFloat:xAxisLength]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:yAxisStart] length:[NSNumber numberWithFloat:yAxisLength]];
    
    CPTScatterPlot *absorbanceSourceLinePlot = [[CPTScatterPlot alloc] init];
    [absorbanceSourceLinePlot setIdentifier:@"absorbancePlot"];
    
    CPTMutableLineStyle *absorbanceLineStyle = [CPTMutableLineStyle lineStyle];
    absorbanceLineStyle.lineWidth = 1.2f;
    absorbanceLineStyle.lineColor = [CPTColor purpleColor];
    absorbanceSourceLinePlot.dataLineStyle = absorbanceLineStyle;
    absorbanceSourceLinePlot.dataSource = self;
    
    //self.peakValueLabel.text = [NSString stringWithFormat:@"%.lf",self.maxLocation2];
    [absorbanceGraph addPlot:absorbanceSourceLinePlot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
