//
//  AnalysisMasterViewController.m
//  inSPECtor
//
//  Created by Jeremy Storer on 10/13/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import "AnalysisMasterViewController.h"
#import "DownPicker.h"
#import "Singleton.h"
#import <MessageUI/MessageUI.h>

@interface AnalysisMasterViewController ()

@end

@implementation AnalysisMasterViewController

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
    self.knowareButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.knowareButton.layer.borderWidth = 1.0;
    self.knowareButton.layer.cornerRadius = 10.0;
    
    self.csvButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.csvButton.layer.borderWidth = 1.0;
    self.csvButton.layer.cornerRadius = 10.0;
    
    self.nextButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.nextButton.layer.borderWidth = 1.0;
    self.nextButton.layer.cornerRadius = 10.0;
    
    self.backButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.backButton.layer.borderWidth = 1.0;
    self.backButton.layer.cornerRadius = 10.0;

    // Do any additional setup after loading the view.
    Singleton *singleton = [Singleton sharedManager];
    NSMutableArray *chemicals = [[NSMutableArray alloc]init];
    
    [chemicals addObject:@"nitrate"];
    [chemicals addObject:@"nitrite"];
    [chemicals addObject:@"phosphorus"];
    
    self.picker = [[DownPicker alloc] initWithTextField:self.chemicalPicker withData:chemicals];
    
    self.maxPeakLocation     = [[NSMutableArray alloc] init];
    self.maxPeakValues       = [[NSMutableArray alloc] init];
    self.maxLocationForGraph = [[NSMutableArray alloc] init];
    self.peakSeperationValue = [[NSNumber alloc] init];
    self.peakSeperationValue = [NSNumber numberWithInt:20];
    
    self.max1 = 0;         self.max2 = 0;         self.max3 = 0;
    self.maxLocation1 = 0; self.maxLocation2 = 0; self.maxLocation3 = 0;
    
    for(int i = 1; i < [singleton.locationArray count] - 1; i++){
        //if there is a peak
        if([singleton.absorbance[i] floatValue] > self.max1){
            self.max1 = [singleton.absorbance[i] floatValue];
            self.maxLocation1 = i;
        }
    }
    
    self.max2 = self.max1;
    self.maxLocation2 = self.maxLocation1;
    
    
    [self.maxLocationForGraph addObject:[NSNumber numberWithDouble:self.maxLocation1]];
    [self.maxLocationForGraph addObject:[NSNumber numberWithDouble:self.maxLocation2]];
    
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
//    axisSet.xAxis.majorTickLineStyle = lineStyle;
//    axisSet.xAxis.minorTickLineStyle = nil;
//    axisSet.xAxis.majorTickLength = -500.0f;
//    //    axisSet.xAxis.majorTickLocations = [NSSet setWithArray:self.maxLocationForGraph];
//    // axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(100.0f);
//    axisSet.xAxis.minorTicksPerInterval = 0;
//    
//    NSUInteger labelLocation = 0;
//    NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[self.maxLocationForGraph count]];
//    for(NSNumber *tickLocation in self.maxLocationForGraph){
//        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc]initWithText:[NSString stringWithFormat:@"%@",[self.maxLocationForGraph objectAtIndex:labelLocation++]] textStyle:axisSet.xAxis.labelTextStyle = xTextStyle];
//        newLabel.tickLocation = tickLocation;
//        newLabel.offset = axisSet.xAxis.labelOffset;
//        newLabel.rotation = M_PI / 2;
//        [customLabels addObject:newLabel];
//    }
//    axisSet.xAxis.axisLabels = customLabels;
    
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

- (IBAction)calculateButtonPressed:(id)sender {
    Singleton *singleton = [Singleton sharedManager];
    singleton.selectedTest = [self.picker text];
    if (self.picker.text.length > 0) {
        [self performSegueWithIdentifier:@"secondaryAnalysis" sender:self];
    }
    
    self.nitrateppm = fabs(([singleton.absorbance[(int)self.maxLocation2] floatValue] -0.0326) / 0.0349);
}

- (IBAction)exportCSVButtonPressed:(id)sender {
     Singleton *singleton = [Singleton sharedManager];
    Class emailClass=(NSClassFromString(@"MFMailComposeViewController"));
    
    if(emailClass != nil){
        NSMutableString *writeString = [[NSMutableString alloc]initWithCapacity:0 ];
        [writeString appendString:@"Location,raw1B,raw1G,raw1R,raw1I,raw2I,raw3I,avgRaw,samp1B,samp1G,samp1R,samp1I,samp2I,samp3I,sampAvgI,absorbance,smoothedAbsorbance\n"];
        for(int i = 0; i < [singleton.locationArray count]; i++){
            [writeString appendFormat:@"%@,%@,%@,%@,%@,%@,%@,%f,%@,%@,%@,%@,%@,%@,%f,%@,%@\n",singleton.locationArray[i],
             singleton.baseBlueIntensity[i],
             singleton.baseGreenIntensity[i],
             singleton.baseRedIntensity[i],
             singleton.baselightIntensity1[i],singleton.baselightIntensity2[i],singleton.baselightIntensity3[i],([singleton.baselightIntensity1[i] floatValue]+[singleton.baselightIntensity2[i] floatValue]+[singleton.baselightIntensity3[i] floatValue])/3.0,singleton.sampleBlueIntensity[i],singleton.sampleGreenIntensity[i],singleton.sampleRedIntensity[i],singleton.samplelightIntensity1[i],singleton.samplelightIntensity2[i],singleton.samplelightIntensity3[i],([singleton.samplelightIntensity1[i] floatValue]+[singleton.samplelightIntensity2[i] floatValue]+[singleton.samplelightIntensity3[i] floatValue])/3.0,singleton.absorbance[i],singleton.smoothedAbsorbance[i]] ;
        }
        NSData *csvData = [writeString dataUsingEncoding:NSUTF8StringEncoding];
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        if([MFMailComposeViewController canSendMail]){
            mailController.mailComposeDelegate = self;
            [mailController addAttachmentData:csvData mimeType:@"text/csv" fileName:@"myfile.csv"];
            [mailController setMessageBody:@"CSV File from InSPECTor." isHTML:NO];
            [mailController setSubject:@"CSV File from InSPECtor"];
            // [self presentModalViewController:mailController animated:YES];
            [self presentViewController:mailController animated:YES completion:NULL];
        }
        else{
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Email cannot be send!"
                                                             message:@"Device is not configured to send email"
                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Email cannot be send!"
                                                     message:@"Device cannot send email"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
//    
//    // Close the Mail Interface
//    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    UIAlertView *alert;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc] initWithTitle:@"Draft Saved" message:@"Composed Mail is saved in draft." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultSent:
            alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Message Sent." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Sorry! Failed to send." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)knowareButtonPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"com.KnoWare.Editor://?inspectorAnswer=%f",self.nitrateppm]];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
