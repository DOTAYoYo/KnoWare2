//
//  RGBViewController.m
//  InSPECtor
//
//  Created by Jeremy Storer on 3/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "RGBViewController.h"
#import "Singleton.h"

@interface RGBViewController ()

@end

@implementation RGBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Singleton *singleton = [Singleton sharedManager];

    UIImage *rotatedImage;
    
    rotatedImage = [self rotate: singleton.baselightImage1 andOrientation: singleton.baselightImage1.imageOrientation];
    self.baselightImage.image = rotatedImage;
    [self graphIntensity];
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


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    Singleton *singleton = [Singleton sharedManager];
    return [singleton.locationArray count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
    Singleton *singleton = [Singleton sharedManager];
    
    NSLog(@"%@",[plot identifier]);
    if([[plot identifier] isEqual:@"redLight"]){
        if(fieldEnum == CPTScatterPlotFieldX){
            return [singleton.locationArray objectAtIndex:idx];
        }
        else{
            return [singleton.baseRedIntensity objectAtIndex:idx];
        }
    }
    else if([[plot identifier] isEqual:@"greenLight"]){
        if(fieldEnum == CPTScatterPlotFieldX){
            return [singleton.locationArray objectAtIndex:idx];
        }
        else{
            return [singleton.baseGreenIntensity objectAtIndex:idx];
        }
    }
    else if([[plot identifier] isEqual:@"blueLight"]){
        if(fieldEnum == CPTScatterPlotFieldX){
            return [singleton.locationArray objectAtIndex:idx];
        }
        else{
            return [singleton.baseBlueIntensity objectAtIndex:idx];
        }
    }
    else
        return 0;
}

-(void)graphIntensity{
    Singleton *singleton = [Singleton sharedManager];
    double xAxisStart = 0.0;
    double xAxisLength = [singleton.locationArray count];
    
    double yAxisStart = 0.0;
    double yAxisLength = 250.0;
    
    CPTXYGraph *intensityGraph = [[CPTXYGraph alloc]initWithFrame:self.hostView.bounds];
    
    self.hostView.hostedGraph = intensityGraph;
    intensityGraph.paddingBottom = 0.0;
    intensityGraph.paddingLeft = 0.0;
    intensityGraph.paddingTop = 0.0;
    intensityGraph.paddingRight = 0.0;
    
    intensityGraph.plotAreaFrame.paddingBottom = 20.0;
    intensityGraph.plotAreaFrame.paddingLeft = 30.0;
    intensityGraph.plotAreaFrame.paddingTop = 30.0;
    intensityGraph.plotAreaFrame.paddingRight = 10.0;
    
    //[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blueColor];
    titleStyle.fontName = @"Helvetica-Light";
    titleStyle.fontSize = 10.0f;
    
    NSString *title = @"RGB Values";
    intensityGraph.title = title;
    intensityGraph.titleTextStyle = titleStyle;
    intensityGraph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    intensityGraph.titleDisplacement = CGPointMake(10.0f, -18.0f);
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) intensityGraph.axisSet;
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    CPTMutableTextStyle *xTextStyle = [CPTMutableTextStyle textStyle];
    xTextStyle.fontName = @"Helvetica-Light";
    xTextStyle.fontSize = 8.0f;
    
    axisSet.xAxis.labelTextStyle = xTextStyle;
    axisSet.yAxis.labelTextStyle = xTextStyle;
    
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0f;
    
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    
    axisSet.xAxis.title = @"Pixel Location";
    axisSet.xAxis.labelTextStyle = xTextStyle;
    
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = nil;
    axisSet.xAxis.majorTickLength = 3.0f;
    axisSet.xAxis.majorIntervalLength = [NSNumber numberWithFloat: 400.0];
    axisSet.xAxis.minorTicksPerInterval = 0;
    
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = nil;
    axisSet.yAxis.majorTickLength = 3.0f;
    axisSet.yAxis.majorIntervalLength = [NSNumber numberWithFloat:50.0];
    axisSet.yAxis.minorTicksPerInterval = 0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)intensityGraph.defaultPlotSpace;
    
    CPTPlotRange *xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0] length:[NSNumber numberWithFloat:xAxisLength]];
    [CPTAnimation animate:plotSpace property:@"xRange" fromPlotRange: plotSpace.xRange toPlotRange:xRange duration:2.5 withDelay:0 animationCurve:CPTAnimationCurveDefault delegate:nil];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:xAxisStart] length:[NSNumber numberWithFloat:xAxisLength]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:yAxisStart] length:[NSNumber numberWithFloat:yAxisLength]];
    
    CPTScatterPlot *redSourceLinePlot = [[CPTScatterPlot alloc] init];
    [redSourceLinePlot setIdentifier:@"redLight"];
    CPTMutableLineStyle *redLineStyle = [CPTMutableLineStyle lineStyle];
    redSourceLinePlot.title = @"Red";
    redLineStyle.lineWidth = 1.2f;
    redLineStyle.lineColor = [CPTColor redColor];
    redSourceLinePlot.dataLineStyle = redLineStyle;
    redSourceLinePlot.dataSource = self;
    
    CPTScatterPlot *blueSourceLinePlot = [[CPTScatterPlot alloc] init];
    [blueSourceLinePlot setIdentifier:@"blueLight"];
    CPTMutableLineStyle *blueLineStyle = [CPTMutableLineStyle lineStyle];
    blueSourceLinePlot.title = @"Blue";
    blueLineStyle.lineWidth = 1.2f;
    blueLineStyle.lineColor = [CPTColor blueColor];
    //blueLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:3],[NSDecimalNumber numberWithInt:3],nil];
    blueSourceLinePlot.dataLineStyle = blueLineStyle;
    blueSourceLinePlot.dataSource = self;
    
    CPTScatterPlot *greenSourceLinePlot = [[CPTScatterPlot alloc] init];
    [greenSourceLinePlot setIdentifier:@"greenLight"];
    CPTMutableLineStyle *greenLineStyle = [CPTMutableLineStyle lineStyle];
    greenSourceLinePlot.title = @"Green";
    greenLineStyle.lineWidth = 1.2f;
    greenLineStyle.lineColor = [CPTColor greenColor];
    //greenLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:3],[NSDecimalNumber numberWithInt:3],nil];
    greenSourceLinePlot.dataLineStyle = greenLineStyle;
    greenSourceLinePlot.dataSource = self;
    
    
    
    [intensityGraph addPlot:redSourceLinePlot];
    [intensityGraph addPlot:greenSourceLinePlot];
    [intensityGraph addPlot:blueSourceLinePlot];
    
    intensityGraph.legend = [CPTLegend legendWithGraph:intensityGraph];
    intensityGraph.legend.textStyle = xTextStyle;
    intensityGraph.legend.numberOfColumns = 1;
    intensityGraph.legend.numberOfRows = 3;
    //graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
    intensityGraph.legend.borderLineStyle = lineStyle;
    intensityGraph.legend.cornerRadius = 5.0;
    intensityGraph.legend.swatchSize = CGSizeMake(10.0, 10.0);
    intensityGraph.legendAnchor = CPTRectAnchorTopRight;
    intensityGraph.legendDisplacement = CGPointMake(0.0, 5.0);
    
}

-(UIImage*) rotate:(UIImage*) src andOrientation:(UIImageOrientation)orientation
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context=(UIGraphicsGetCurrentContext());
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90/180*M_PI) ;
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90/180*M_PI);
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 90/180*M_PI);
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}


@end
