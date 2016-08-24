//
//  BaseLightGraphViewController.m
//  inSPECtor
//
//  Created by Jeremy Storer on 10/11/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import "BaseLightGraphViewController.h"
#import "Singleton.h"

@interface BaseLightGraphViewController ()

@end
@implementation BaseLightGraphViewController

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
    
    self.baselightImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.baselightImageView.layer.borderWidth = 1.0;
    self.baselightImageView.layer.cornerRadius = 10.0;
    
    UIImage *rotatedImage1, *rotatedImage2, *rotatedImage3;
    
    rotatedImage2 = [self rotate: singleton.baselightImage2 andOrientation: singleton.baselightImage2.imageOrientation];
    rotatedImage3 = [self rotate: singleton.baselightImage3 andOrientation: singleton.baselightImage3.imageOrientation];
    rotatedImage1 = [self rotate: singleton.baselightImage1 andOrientation: singleton.baselightImage1.imageOrientation];
    
    [singleton.baseRedIntensity removeAllObjects];
    [singleton.baseBlueIntensity removeAllObjects];
    [singleton.baseGreenIntensity removeAllObjects];
    [self cropAndAddToArray:singleton.baselightIntensity1 image:rotatedImage1 getRGB:1];
    [self cropAndAddToArray:singleton.baselightIntensity2 image:rotatedImage2 getRGB:0];
    [self cropAndAddToArray:singleton.baselightIntensity3 image:rotatedImage3 getRGB:0];
    
    [singleton.baselightIntensity removeAllObjects];
    [singleton.locationArray removeAllObjects];
    for (int i = 0; i < [singleton.baselightIntensity1 count]; i++) {
        [singleton.baselightIntensity addObject:[NSNumber numberWithFloat:([singleton.baselightIntensity1[i] floatValue] + [singleton.baselightIntensity2[i] floatValue] + [singleton.baselightIntensity3[i] floatValue])/3.0]];
        [singleton.locationArray addObject: [NSNumber numberWithInteger:i]];
    }
    
#pragma mark Graph Creation
    double xAxisStart = 0.0;
    double xAxisLength = [singleton.locationArray count];
    
    double yAxisStart = 0.0;
    double yAxisLength = 250.0;
    
    CPTXYGraph *graph = [[CPTXYGraph alloc]initWithFrame:self.hostView.bounds];
    
    self.hostView.hostedGraph = graph;
    graph.paddingBottom = 0.0;
    graph.paddingLeft = 0.0;
    graph.paddingTop = 0.0;
    graph.paddingRight = 0.0;
    
    graph.plotAreaFrame.paddingBottom = 20.0;
    graph.plotAreaFrame.paddingLeft = 30.0;
    graph.plotAreaFrame.paddingTop = 5.0;
    graph.plotAreaFrame.paddingRight = 10.0;
    
    //[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blueColor];
    titleStyle.fontName = @"Helvetica-Light";
    titleStyle.fontSize = 10.0f;
    
    NSString *title = @"Pixel Location vs Intensity";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(15.0f, 15.0f);
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
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
    axisSet.yAxis.majorIntervalLength = [NSNumber numberWithFloat:50.0];
    axisSet.yAxis.minorTicksPerInterval = 0;
    
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    
    CPTPlotRange *xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:0.0] length:[NSNumber numberWithFloat: xAxisLength]];
    [CPTAnimation animate:plotSpace property:@"xRange" fromPlotRange: plotSpace.xRange toPlotRange:xRange duration:2.5 withDelay:0 animationCurve:CPTAnimationCurveDefault delegate:nil];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber  numberWithFloat:xAxisStart] length:[NSNumber numberWithFloat:xAxisLength]];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber  numberWithFloat:yAxisStart] length:[NSNumber numberWithFloat:yAxisLength]];
    
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *dataLineStyle = [CPTMutableLineStyle lineStyle];
    dataLineStyle.lineWidth = 1.2f;
    dataLineStyle.lineColor = [CPTColor blueColor];
    dataLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:3],[NSDecimalNumber numberWithInt:3],nil];
    dataSourceLinePlot.dataLineStyle = dataLineStyle;
    dataSourceLinePlot.dataSource = self;
    dataSourceLinePlot.title = @"Base";
    
    
    [graph addPlot:dataSourceLinePlot];
    
    graph.legend = [CPTLegend legendWithGraph:graph];
    graph.legend.textStyle = xTextStyle;
    graph.legend.numberOfColumns = 1;
    graph.legend.numberOfRows = 1;
    //graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
    graph.legend.borderLineStyle = lineStyle;
    graph.legend.cornerRadius = 5.0;
    graph.legend.swatchSize = CGSizeMake(10.0, 10.0);
    graph.legendAnchor = CPTRectAnchorTopRight;
    graph.legendDisplacement = CGPointMake(0.0, 15.0);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    Singleton *singleton = [Singleton sharedManager];
    return [singleton.locationArray count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
    Singleton *singleton = [Singleton sharedManager];
    if(fieldEnum == CPTScatterPlotFieldX){
        return [singleton.locationArray objectAtIndex:idx];
    }
    else{
        return [singleton.baselightIntensity objectAtIndex:idx];
    }
    
}

-(void) cropAndAddToArray:(NSMutableArray *) intensityArray image:(UIImage *)rotatedImage getRGB:(NSInteger *)getRGB {
    
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
    
    
    for (int x = 0 ; x <width; x++){
        NSUInteger byteIndex = (bytesPerRow * height/2) + x * bytesPerPixel;
        float blue = rawData[byteIndex+2];
        if(blue > 25){
            singleton.cropStartLocation = x;
            startLocation = x;
            break;
        }
        
    }
    for(int x = width; x > 0; x--){
        NSUInteger byteIndex = (bytesPerRow * height/2) + x * bytesPerPixel;
        float red = rawData[byteIndex];
        if(red > 45){
            singleton.cropEndLocation = x;
            endLocation = x;
            break;
        }
        
    }
    
    for(int y = 0; y < height; y++){
        int blueStarted = 0, greenStarted = 0,redStarted = 0,getEndLocation = 0;
        //int startLocation = 0,endLocation = 0;
        for(int x = 0; x <width; x++){
            NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            float red = rawData[byteIndex],green = rawData[byteIndex+1],blue = rawData[byteIndex+2];
            if(y==height/2 && getRGB == 1){
                [singleton.baseRedIntensity addObject:[NSNumber numberWithFloat:red]];
                [singleton.baseGreenIntensity addObject:[NSNumber numberWithFloat:green]];
                [singleton.baseBlueIntensity addObject:[NSNumber numberWithFloat:blue]];
            }
            
//            if(y==height/2){
//                NSLog(@"red: %f  green: %f, blue: %f",red,green,blue);
//            }
//            
//            if(blue > 50 && blueStarted == 0){
//                if(y==height/2){
//                    blueStarted = 1;
//                    singleton.cropStartLocation = x;
//                    startLocation = x;
//                }
//            }
//            if(red < 60 && getEndLocation == 0 && greenStarted == 1){
//                if(y==height/2){
//                    getEndLocation = 1;
//                    singleton.cropEndLocation = x;
//                    endLocation = x;
//                }
//            }
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
    self.baselightImageView.image = newImage;
    
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
