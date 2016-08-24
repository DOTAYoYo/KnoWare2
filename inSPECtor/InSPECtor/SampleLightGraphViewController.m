//
//  SampleLightGraphViewController.m
//  inSPECtor
//
//  Created by Jeremy Storer on 10/12/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import "SampleLightGraphViewController.h"
#import <CorePlot/ios/CorePlot.h>
#import "Singleton.h"
#import <math.h>


@interface SampleLightGraphViewController ()

@end

@implementation SampleLightGraphViewController

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    Singleton *singleton = [Singleton sharedManager];

    //  NSLog(@"count: %lu",(unsigned long)[self.intensityArray count]);
    if([[plot identifier] isEqual:@"sampleLightPlot"])
        return [singleton.locationArray count];
    else if([[plot identifier] isEqual:@"baseLightPlot"])
        return [singleton.locationArray count];
    else if([[plot identifier] isEqual:@"absorbancePlot"])
        return [singleton.locationArray count];
    
    else
        return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
    Singleton *singleton = [Singleton sharedManager];

    //  NSLog(@"number flor plot");
    if([[plot identifier] isEqual:@"sampleLightPlot"]){
        if(fieldEnum == CPTScatterPlotFieldX){
            return [singleton.locationArray objectAtIndex:idx];
        }
        else{
            return [singleton.samplelightIntensity objectAtIndex:idx];
        }
    }
    else if([[plot identifier] isEqual:@"baseLightPlot"]){
        if(fieldEnum == CPTScatterPlotFieldX){
            return [singleton.locationArray objectAtIndex:idx];
        }
        else{
            return [singleton.baselightIntensity objectAtIndex:idx];
        }
    }
    else if([[plot identifier] isEqual:@"absorbancePlot"]){
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
    
    self.nextButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.nextButton.layer.borderWidth = 1.0;
    self.nextButton.layer.cornerRadius = 10.0;
    
    self.backButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.backButton.layer.borderWidth = 1.0;
    self.backButton.layer.cornerRadius = 10.0;
    
    UIImage *rotatedImage1, *rotatedImage2, *rotatedImage3;
    UIImage *rotatedImage4, *rotatedImage5, *rotatedImage6;
    
    rotatedImage1 = [self rotate: singleton.baselightImage1 andOrientation: singleton.baselightImage1.imageOrientation];
    rotatedImage2 = [self rotate: singleton.baselightImage2 andOrientation: singleton.baselightImage2.imageOrientation];
    rotatedImage3 = [self rotate: singleton.baselightImage3 andOrientation: singleton.baselightImage3.imageOrientation];
    
    self.baselightImageView.image = rotatedImage1;
    
    rotatedImage4 = [self rotate: singleton.samplelightImage1 andOrientation: singleton.baselightImage1.imageOrientation];
    rotatedImage5 = [self rotate: singleton.samplelightImage2 andOrientation: singleton.baselightImage2.imageOrientation];
    rotatedImage6 = [self rotate: singleton.samplelightImage3 andOrientation: singleton.baselightImage3.imageOrientation];
    
    [singleton.sampleRedIntensity removeAllObjects];
    [singleton.sampleGreenIntensity removeAllObjects];
    [singleton.sampleBlueIntensity removeAllObjects];
    [singleton.samplelightIntensity1 removeAllObjects];
    [singleton.samplelightIntensity2 removeAllObjects];
    [singleton.samplelightIntensity3 removeAllObjects];

//    [self cropAndAddToArray:singleton.baselightIntensity1 image:rotatedImage1 spectra:@"base" getRGB:0];
//    [self cropAndAddToArray:singleton.baselightIntensity2 image:rotatedImage2 spectra:@"base" getRGB:0];
//    [self cropAndAddToArray:singleton.baselightIntensity3 image:rotatedImage3 spectra:@"base" getRGB:0];
    
    [self cropAndAddToArray:singleton.samplelightIntensity1 image:rotatedImage4 spectra:@"sample" getRGB:1];
    [self cropAndAddToArray:singleton.samplelightIntensity2 image:rotatedImage5 spectra:@"sample" getRGB:0];
    [self cropAndAddToArray:singleton.samplelightIntensity3 image:rotatedImage6 spectra:@"sample" getRGB:0];
    
    [singleton.baselightIntensity removeAllObjects];
    [singleton.samplelightIntensity removeAllObjects];
    [singleton.locationArray removeAllObjects];
    [singleton.absorbance removeAllObjects];
    [singleton.smoothedAbsorbance removeAllObjects];
    
    int smoothingFactor = 2;
    
    for (int i = 0; i < [singleton.baselightIntensity1 count]; i++) {
        
        if (i < smoothingFactor/2 || i > [singleton.baselightIntensity1 count] - smoothingFactor/2) {
        [singleton.baselightIntensity addObject:[NSNumber numberWithFloat:([singleton.baselightIntensity1[i] floatValue] + [singleton.baselightIntensity2[i] floatValue] + [singleton.baselightIntensity3[i] floatValue])/3.0]];
        [singleton.samplelightIntensity addObject:[NSNumber numberWithFloat:([singleton.samplelightIntensity1[i] floatValue] + [singleton.samplelightIntensity2[i] floatValue] + [singleton.samplelightIntensity3[i] floatValue])/3.0]];
        [singleton.locationArray addObject: [NSNumber numberWithInteger:i]];
        }else{
            float smoothedBaseIntensity = 0.0, smoothedSampleIntensity = 0.0;
            for (int j=i-smoothingFactor/2; j<i+smoothingFactor/2 ; j++) {
                smoothedBaseIntensity += ([singleton.baselightIntensity1[i] floatValue] + [singleton.baselightIntensity2[i] floatValue] + [singleton.baselightIntensity3[i] floatValue])/3.0;
                smoothedSampleIntensity += ([singleton.samplelightIntensity1[i] floatValue] + [singleton.samplelightIntensity2[i] floatValue] + [singleton.samplelightIntensity3[i] floatValue])/3.0;
            }
            [singleton.baselightIntensity addObject:[NSNumber numberWithFloat:smoothedBaseIntensity/smoothingFactor]];
            [singleton.samplelightIntensity addObject:[NSNumber numberWithFloat:smoothedSampleIntensity/smoothingFactor]];
            [singleton.locationArray addObject: [NSNumber numberWithInteger:i]];
        }
       
        float I0 = [singleton.baselightIntensity[i] floatValue];
        float I = [singleton.samplelightIntensity[i] floatValue];
        float A = log10f(I0/I);
        if(i > singleton.cropStartLocation + smoothingFactor/2 && i < singleton.cropEndLocation - smoothingFactor/2 && I0 != 0 && I != 0){
            [singleton.absorbance addObject:[NSNumber numberWithFloat:A]];
        }else{
            [singleton.absorbance addObject:[NSNumber numberWithFloat:0.0]];
        }
    }
    singleton = [Singleton sharedManager];
    int absorbanceSmoothingFactor = 100;
    for (int i = 0; i < [singleton.absorbance count]; i++) {
        if (i < absorbanceSmoothingFactor/2 || i > [singleton.absorbance count] - absorbanceSmoothingFactor/2){
            [singleton.smoothedAbsorbance addObject:[NSNumber numberWithFloat:[singleton.absorbance[i] floatValue]]];
        }else{
            float absorbanceSmoothedIntensity=0;
            for (int j = i-absorbanceSmoothingFactor/2; j < i+absorbanceSmoothingFactor/2; j++){
                absorbanceSmoothedIntensity = absorbanceSmoothedIntensity + [singleton.absorbance[j] floatValue];
            }
            [singleton.smoothedAbsorbance addObject:[NSNumber numberWithFloat:(absorbanceSmoothedIntensity/absorbanceSmoothingFactor)]];
            NSLog(@"%f %f %f",absorbanceSmoothedIntensity,[singleton.absorbance[i] floatValue],[singleton.smoothedAbsorbance[i] floatValue]);
        }
    }
    
//    for(int i = 0; i <[singleton.absorbance count]; i++){
//        if(i < absorbanceSmoothingFactor / 2 || i > [singleton.absorbance count] - absorbanceSmoothingFactor / 2){
//            NSLog(@"%i",i);
//        }else{
//            float absorbanceSmoothedIntensity = 0;
//            for(int j = i - absorbanceSmoothingFactor / 2; j < i+ absorbanceSmoothingFactor / 2; j++){
//                absorbanceSmoothedIntensity += [singleton.absorbance[i] floatValue];
//            }
//            
//        }
//    }
    
    singleton = [Singleton sharedManager];
    [self graphIntensity];
    [self graphAbsorbance];
}

-(void)graphIntensity{
    Singleton *singleton = [Singleton sharedManager];
    double xAxisStart = 0.0;
    double xAxisLength = [singleton.locationArray count];
    
    double yAxisStart = 0.0;
    double yAxisLength = 250.0;
    
    CPTXYGraph *intensityGraph = [[CPTXYGraph alloc]initWithFrame:self.intensityHostView.bounds];
    
    self.intensityHostView.hostedGraph = intensityGraph;
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
    
    NSString *title = @"Pixel Location vs Intensity";
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
    
    CPTScatterPlot *sampleSourceLinePlot = [[CPTScatterPlot alloc] init];
    [sampleSourceLinePlot setIdentifier:@"sampleLightPlot"];
    CPTMutableLineStyle *sampleLineStyle = [CPTMutableLineStyle lineStyle];
    sampleSourceLinePlot.title = @"Sample";
    sampleLineStyle.lineWidth = 1.2f;
    sampleLineStyle.lineColor = [CPTColor blackColor];
    sampleSourceLinePlot.dataLineStyle = sampleLineStyle;
    sampleSourceLinePlot.dataSource = self;
    
    CPTScatterPlot *baseSourceLinePlot = [[CPTScatterPlot alloc] init];
    [baseSourceLinePlot setIdentifier:@"baseLightPlot"];
    CPTMutableLineStyle *baseLineStyle = [CPTMutableLineStyle lineStyle];
    baseSourceLinePlot.title = @"Raw";
    baseLineStyle.lineWidth = 1.2f;
    baseLineStyle.lineColor = [CPTColor blueColor];
    baseLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:3],[NSDecimalNumber numberWithInt:3],nil];
    baseSourceLinePlot.dataLineStyle = baseLineStyle;
    baseSourceLinePlot.dataSource = self;
    
    [intensityGraph addPlot:sampleSourceLinePlot];
    [intensityGraph addPlot:baseSourceLinePlot];
    
    intensityGraph.legend = [CPTLegend legendWithGraph:intensityGraph];
    intensityGraph.legend.textStyle = xTextStyle;
    intensityGraph.legend.numberOfColumns = 1;
    intensityGraph.legend.numberOfRows = 2;
    //graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
    intensityGraph.legend.borderLineStyle = lineStyle;
    intensityGraph.legend.cornerRadius = 5.0;
    intensityGraph.legend.swatchSize = CGSizeMake(10.0, 10.0);
    intensityGraph.legendAnchor = CPTRectAnchorTopRight;
    intensityGraph.legendDisplacement = CGPointMake(0.0, 5.0);
    
}

-(void)graphAbsorbance{
    Singleton *singleton = [Singleton sharedManager];
    float xAxisStart = 0.0;
    float xAxisLength = [singleton.locationArray count];
    
    float yAxisStart = 0.0;
    NSNumber *findYMax = [singleton.absorbance valueForKeyPath:@"@max.self"];
    // float yAxisLength = [findYMax floatValue] + 0.05;
    float yAxisLength = 1.0;
    
    CPTXYGraph *absorbanceGraph = [[CPTXYGraph alloc]initWithFrame:self.absorbanceHostView.bounds];
    
    self.absorbanceHostView.hostedGraph = absorbanceGraph;
    absorbanceGraph.paddingBottom = 0.0;
    absorbanceGraph.paddingLeft = 0.0;
    absorbanceGraph.paddingTop = 10.0;
    absorbanceGraph.paddingRight = 0.0;
    
    absorbanceGraph.plotAreaFrame.paddingBottom = 20.0;
    absorbanceGraph.plotAreaFrame.paddingLeft = 30.0;
    absorbanceGraph.plotAreaFrame.paddingTop = 30.0;
    absorbanceGraph.plotAreaFrame.paddingRight = 10.0;
    
    //[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blueColor];
    titleStyle.fontName = @"Helvetica-Light";
    titleStyle.fontSize = 10.0f;
    
    NSString *title = @"Absorbance";
    absorbanceGraph.title = title;
    absorbanceGraph.titleTextStyle = titleStyle;
    absorbanceGraph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    absorbanceGraph.titleDisplacement = CGPointMake(0.0f, -10.0f);
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) absorbanceGraph.axisSet;
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
    axisSet.xAxis.majorIntervalLength = [NSNumber numberWithFloat:400.0];
    axisSet.xAxis.minorTicksPerInterval = 0;
    
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = nil;
    axisSet.yAxis.majorTickLength = 3.0f;
    axisSet.yAxis.majorIntervalLength = [NSNumber numberWithFloat:0.2];
    axisSet.yAxis.minorTicksPerInterval = 0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)absorbanceGraph.defaultPlotSpace;
    
    CPTPlotRange *xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0] length:[NSNumber numberWithFloat:xAxisLength]];
    [CPTAnimation animate:plotSpace property:@"xRange" fromPlotRange: plotSpace.xRange toPlotRange:xRange duration:2.5 withDelay:0 animationCurve:CPTAnimationCurveDefault delegate:nil];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:400.0] length:[NSNumber numberWithFloat:xAxisStart]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:yAxisStart]length:[NSNumber numberWithFloat:yAxisLength]];
    
    CPTScatterPlot *absorbanceSourceLinePlot = [[CPTScatterPlot alloc] init];
    [absorbanceSourceLinePlot setIdentifier:@"absorbancePlot"];
    CPTMutableLineStyle *absorbanceLineStyle = [CPTMutableLineStyle lineStyle];
    absorbanceLineStyle.lineWidth = 0.8f;
    absorbanceLineStyle.lineColor = [CPTColor darkGrayColor];
    absorbanceSourceLinePlot.dataLineStyle = absorbanceLineStyle;
    absorbanceSourceLinePlot.dataSource = self;
    
    
    [absorbanceGraph addPlot:absorbanceSourceLinePlot];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) cropAndAddToArray:(NSMutableArray *) intensityArray image:(UIImage *)rotatedImage spectra:(NSString *)spectra getRGB:(NSInteger *)getRGB{
    
    [intensityArray removeAllObjects];
    float startLocation=0.0,endLocation=0.0;
    Singleton *singleton = [Singleton sharedManager];
    CGImageRef image = [rotatedImage CGImage];
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    startLocation = (int)singleton.cropStartLocation;
    endLocation = (int)singleton.cropEndLocation;
    
    for(int y = 0; y < height; y++){
        int blueStarted = 0, greenStarted = 0,redStarted = 0,getEndLocation = 0;
        //int startLocation = 0,endLocation = 0;
        for(int x = 0; x <width; x++){
            NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            float red = rawData[byteIndex],green = rawData[byteIndex+1],blue = rawData[byteIndex+2];
            if(y==height/2 && getRGB == 1){
                [singleton.sampleRedIntensity addObject:[NSNumber numberWithFloat:red]];
                [singleton.sampleGreenIntensity addObject:[NSNumber numberWithFloat:green]];
                [singleton.sampleBlueIntensity addObject:[NSNumber numberWithFloat:blue]];
            }
            
        }
    }
    
    for(int y = 0; y < height; y++){
        for(int x = 0; x < width; x++) {
            NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            NSUInteger byteIndexOneDown = (bytesPerRow * ((y)+20)) + x * bytesPerPixel;
            NSUInteger byteIndexOneUp = (bytesPerRow * ((y)-20)) + x * bytesPerPixel;
            NSUInteger byteIndexRight = (bytesPerRow * y) + (x+1) * bytesPerPixel;
            NSUInteger byteIndexLeft = (bytesPerRow * y) + (x-1) * bytesPerPixel;
            NSUInteger byteIndexRight2 = (bytesPerRow * y) + (x+2) * bytesPerPixel;
            NSUInteger byteIndexLeft2 = (bytesPerRow * y) + (x-2) * bytesPerPixel;
            NSUInteger byteIndexRight3 = (bytesPerRow * y) + (x+3) * bytesPerPixel;
            NSUInteger byteIndexLeft3 = (bytesPerRow * y) + (x-3) * bytesPerPixel;
            
            if(y==height/2){
                float red0 = rawData[byteIndex],       red1 = rawData[byteIndexOneUp],       red2 = rawData[byteIndexOneDown];
                float green0 = rawData[byteIndex + 1], green1 = rawData[byteIndexOneUp + 1], green2 = rawData[byteIndexOneDown + 1];
                float blue0 = rawData[byteIndex + 2],  blue1 = rawData[byteIndexOneUp + 2],  blue2 = rawData[byteIndexOneDown + 2];
                
                float red   = (red0+red1+red2)/3.0;
                float green = (green0+green1+green2)/3.0;
                float blue  = (blue0+blue1+blue2)/3.0;
                
                rawData[byteIndex]     = 255.0;
                rawData[byteIndex + 1] = 255.0;
                rawData[byteIndex + 2] = 255.0;
                
                // int alpha = rawData[byteIndex + 3];
                float intensity = (red + green + blue) / 3.0;
                
                // NSLog(@"%f",intensity);
                if(x > startLocation+5 && x < endLocation-5 ){
                    [intensityArray addObject:[NSNumber numberWithFloat:intensity]];
                }else{
                    [intensityArray addObject:[NSNumber numberWithFloat:0]];
                }
            }
            
            if((x == startLocation || x == endLocation) && startLocation >=2 && endLocation <= width-2 && startLocation <= width - 2 && endLocation >=2){
                rawData[byteIndex] = 255.0;
                rawData[byteIndex+1] = 255.0;
                rawData[byteIndex+2] = 255.0;
                
                rawData[byteIndexLeft] = 255.0;
                rawData[byteIndexLeft+1] = 255.0;
                rawData[byteIndexLeft+2] = 255.0;
                
                rawData[byteIndexRight] = 255.0;
                rawData[byteIndexRight+1] = 255.0;
                rawData[byteIndexRight+2] = 255.0;
                
                rawData[byteIndexLeft2] = 255.0;
                rawData[byteIndexLeft2+1] = 255.0;
                rawData[byteIndexLeft2+2] = 255.0;
                
                rawData[byteIndexRight2] = 255.0;
                rawData[byteIndexRight2+1] = 255.0;
                rawData[byteIndexRight2+2] = 255.0;
                
                rawData[byteIndexLeft3] = 255.0;
                rawData[byteIndexLeft3+1] = 255.0;
                rawData[byteIndexLeft3+2] = 255.0;
                
                rawData[byteIndexRight3] = 255.0;
                rawData[byteIndexRight3+1] = 255.0;
                rawData[byteIndexRight3+2] = 255.0;
                
            }
        }
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rawData, width*height*4, NULL);
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width,height,8,32,4*width,colorSpace,bitmapInfo,provider,NULL,NO,renderingIntent);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    if([spectra isEqualToString:@"base"]){
    self.baselightImageView.image = newImage;
    }else{
    self.samplelightImageView.image = newImage;
    }
    
    // CGImageRelease(image); this is causing an error when released....why????
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
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
