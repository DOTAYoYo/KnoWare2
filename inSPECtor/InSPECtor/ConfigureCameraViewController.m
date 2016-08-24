//
//  ConfigureCameraViewController.m
//  InSPECtor
//
//  Created by Jeremy Storer on 3/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "ConfigureCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CameraSingleton.h"
#import "Singleton.h"
@interface ConfigureCameraViewController ()

@end
AVCaptureDevice *inputDevice1;
AVCaptureSession *session1;
AVCaptureStillImageOutput *stillImageOutput1;

@implementation ConfigureCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Singleton *singleton = [Singleton sharedManager];
  
    float ISO = [singleton.isoValue floatValue];
    int DURATION = [singleton.exposureValue integerValue];
    
    self.durationSlider.value = [singleton.exposureValue integerValue];
    self.durationLabel.text = [NSString stringWithFormat:@"Duration: %f s",1/self.durationSlider.value];

    
    self.ISOSlider.value = [singleton.isoValue floatValue];
    self.ISOLabel.text = [NSString stringWithFormat:@"ISO: %i",(int)self.ISOSlider.value];
    
    self.focusSlider.value = [singleton.lensValue floatValue];
    self.focusLabel.text = [NSString stringWithFormat:@"Focus: %f",self.focusSlider.value];
    
    // Do any additional setup after loading the view.
    session1 = [[AVCaptureSession alloc] init];
    [session1 setSessionPreset:AVCaptureSessionPresetPhoto];
    
    inputDevice1 = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [inputDevice1 lockForConfiguration:FALSE];
    [inputDevice1 setFocusModeLockedWithLensPosition:[singleton.lensValue floatValue] completionHandler:nil];
    [inputDevice1 setExposureModeCustomWithDuration:CMTimeMake(1, DURATION) ISO:ISO completionHandler:nil];
    
    NSLog(@"MaxISO: %f",inputDevice1.activeFormat.maxISO);
    NSLog(@"MinISO: %f",inputDevice1.activeFormat.minISO);
    NSLog(@"Current ISO: %f",inputDevice1.ISO);
    
    NSLog(@"MaxDur: %f",CMTimeGetSeconds(inputDevice1.activeFormat.maxExposureDuration));
    NSLog(@"MinDur: %f",CMTimeGetSeconds(inputDevice1.activeFormat.minExposureDuration));
    NSLog(@"Current Dur: %f",CMTimeGetSeconds(inputDevice1.exposureDuration));
    NSLog(@"##########################");

    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice: inputDevice1 error:&error];
    
    if ([session1 canAddInput:deviceInput]) {
        [session1 addInput:deviceInput];
    }
    
    [inputDevice1 setVideoZoomFactor:2.0f];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session1];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewLayer.frame = self.frameForCapture.bounds;
    [self.frameForCapture.layer addSublayer:previewLayer];
    
    UIView *view = [self frameForCapture];
    CALayer *rootLayer = [view layer];
    [rootLayer setMasksToBounds:YES];
    
    CGRect frame = self.frameForCapture.bounds;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput1 = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [stillImageOutput1 setOutputSettings:outputSettings];
    
    [session1 addOutput:stillImageOutput1];
    
    [session1 startRunning];

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

- (IBAction)durationSliderMoved:(id)sender {
    [inputDevice1 setExposureModeCustomWithDuration:CMTimeMake(1,self.durationSlider.value) ISO:self.ISOSlider.value completionHandler:nil];
    self.durationLabel.text = [NSString stringWithFormat:@"Duration: %f s",1/self.durationSlider.value];

}

- (IBAction)ISOSliderMoved:(id)sender {
    [inputDevice1 setExposureModeCustomWithDuration:CMTimeMake(1,self.durationSlider.value) ISO:self.ISOSlider.value completionHandler:nil];
    self.ISOLabel.text = [NSString stringWithFormat:@"ISO: %i",(int)self.ISOSlider.value];

}

- (IBAction)focusSliderMoved:(id)sender {
    [inputDevice1 setFocusModeLockedWithLensPosition:self.focusSlider.value completionHandler:nil];
    self.focusLabel.text = [NSString stringWithFormat:@"Focus: %f",self.focusSlider.value];

}

- (IBAction)cancelPressed:(id)sender {
}

- (IBAction)applyPressed:(id)sender {
    Singleton *singleton = [Singleton sharedManager];
    singleton.exposureValue = [NSNumber numberWithInteger:self.durationSlider.value];
    singleton.isoValue = [NSNumber numberWithInteger:self.ISOSlider.value];
    singleton.lensValue = [NSNumber numberWithFloat:self.focusSlider.value];

}
@end
