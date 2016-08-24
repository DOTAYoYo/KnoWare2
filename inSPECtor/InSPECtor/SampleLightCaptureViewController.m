//
//  SampleLightCaptureViewController.m
//  inSPECtor
//
//  Created by Jeremy Storer on 10/12/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "SampleLightCaptureViewController.h"
#import "Singleton.h"
#import "CameraSingleton.h"


@interface SampleLightCaptureViewController ()

@end
AVCaptureDevice *inputDevice;
AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

@implementation SampleLightCaptureViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    Singleton *singleton = [Singleton sharedManager];
    // Do any additional setup after loading the view.
    self.captureButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.captureButton.layer.borderWidth = 1.0;
    self.captureButton.layer.cornerRadius = 10.0;
    
    self.nextButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.nextButton.layer.borderWidth = 1.0;
    self.nextButton.layer.cornerRadius = 10.0;
    
    self.backButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.backButton.layer.borderWidth = 1.0;
    self.backButton.layer.cornerRadius = 10.0;
    
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.cornerRadius = 10.0;
    
    self.nextButton.enabled = NO;
//
//    //cameraSingleton.session = [[AVCaptureSession alloc] init];
//    [cameraSingleton.session beginConfiguration];
//    [cameraSingleton.session setSessionPreset:AVCaptureSessionPresetPhoto];
//    
//    cameraSingleton.inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    [cameraSingleton.inputDevice lockForConfiguration:nil];
//    [cameraSingleton.session commitConfiguration];
//    
//    NSLog(@"%f",cameraSingleton.inputDevice.lensPosition);
//    
//    NSError *error;
//    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:cameraSingleton.inputDevice error:&error];
//    
//    if ([cameraSingleton.session canAddInput:deviceInput]) {
//        [cameraSingleton.session addInput:deviceInput];
//    }
//    
//    [cameraSingleton.inputDevice setVideoZoomFactor:2.0f];
//    
//    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:cameraSingleton.session];
//    
//    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    previewLayer.frame = self.frameForCapture.bounds;
//    [self.frameForCapture.layer addSublayer:previewLayer];
//    
//    UIView *view = [self frameForCapture];
//    CALayer *rootLayer = [view layer];
//    [rootLayer setMasksToBounds:YES];
//    
//    CGRect frame = self.frameForCapture.bounds;
//    
//    [previewLayer setFrame:frame];
//    
//    [rootLayer insertSublayer:previewLayer atIndex:0];
//    
//    cameraSingleton.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//    
//    NSDictionary *outputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
//    [cameraSingleton.stillImageOutput setOutputSettings:outputSettings];
//    
//    [cameraSingleton.session addOutput:cameraSingleton.stillImageOutput];
//    
//    [cameraSingleton.session startRunning];
//    [cameraSingleton.inputDevice setFocusModeLockedWithLensPosition:[singleton.lensValue floatValue] completionHandler:nil];
//    [cameraSingleton.inputDevice setExposureModeCustomWithDuration:CMTimeMake(1,[singleton.exposureValue integerValue]) ISO:[singleton.isoValue integerValue] completionHandler:nil];
//    [cameraSingleton.inputDevice unlockForConfiguration];
  //###############################
    
    
    session = [[AVCaptureSession alloc] init];
    [session beginConfiguration];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [inputDevice lockForConfiguration:nil];
    [session commitConfiguration];

    
    
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice: inputDevice error:&error];
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    [inputDevice setVideoZoomFactor:2.0f];

    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewLayer.frame = self.frameForCapture.bounds;
    [self.frameForCapture.layer addSublayer:previewLayer];
    
    UIView *view = [self frameForCapture];
    CALayer *rootLayer = [view layer];
    [rootLayer setMasksToBounds:YES];
    
    CGRect frame = self.frameForCapture.bounds;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
    [inputDevice setFocusModeLockedWithLensPosition:[singleton.lensValue floatValue] completionHandler:nil];
    [inputDevice setExposureModeCustomWithDuration:CMTimeMake(1,[singleton.exposureValue integerValue]) ISO:[singleton.isoValue integerValue] completionHandler:nil];
    [inputDevice unlockForConfiguration];
}

-(void)viewWillDisappear:(BOOL)animated{
    CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    [session removeOutput:stillImageOutput];
    [session stopRunning];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)capturePhoto {
    Singleton *singleton = [Singleton sharedManager];
    CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]){
            if([[port mediaType] isEqual:AVMediaTypeVideo]){
                videoConnection = connection;
                if([videoConnection isVideoOrientationSupported])
                    [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                break;
            }
        }
        if(videoConnection){
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
            singleton.samplelightImage1 = image;
            self.imageView.image = singleton.samplelightImage1;
        }
    }];
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
            singleton.samplelightImage2 = image;
        }
    }];
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
            singleton.samplelightImage3 = image;
        }
    }];
    
    self.nextButton.enabled = YES;
//    Singleton *singleton = [Singleton sharedManager];
//    
//    AVCaptureConnection *videoConnection = nil;
//    
//    for (AVCaptureConnection *connection in stillImageOutput.connections) {
//        for (AVCaptureInputPort *port in [connection inputPorts]){
//            if([[port mediaType] isEqual:AVMediaTypeVideo]){
//                videoConnection = connection;
//                if([videoConnection isVideoOrientationSupported])
//                    [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
//                break;
//            }
//        }
//        if(videoConnection){
//            break;
//        }
//    }
//    
//    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        if (imageDataSampleBuffer != NULL){
//            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//            UIImage *image = [UIImage imageWithData:imageData];
//            
//            image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
//            singleton.samplelightImage1 = image;
//            self.imageView.image = singleton.samplelightImage1;
//        }
//    }];
//    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        if (imageDataSampleBuffer != NULL){
//            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//            UIImage *image = [UIImage imageWithData:imageData];
//            
//            image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
//            singleton.samplelightImage2 = image;
//        }
//    }];
//    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        if (imageDataSampleBuffer != NULL){
//            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//            UIImage *image = [UIImage imageWithData:imageData];
//            
//            image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
//            singleton.samplelightImage3 = image;
//        }
//    }];
//    
//    self.nextButton.enabled = YES;
    
}

- (IBAction)backButtonPressed:(id)sender {
    [session stopRunning];
}

- (IBAction)nextButtonPressed:(id)sender {
    [session stopRunning];
}

- (IBAction)captureButtonPressed:(id)sender {
    Singleton *singleton = [Singleton sharedManager];
    [self capturePhoto];
    singleton = [Singleton sharedManager];
    self.imageView.image = singleton.samplelightImage1;
}


- (UIImage *)cropImage:(UIImage *)image to:(CGRect)cropRect andScaleTo:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef subImage = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    CGRect myRect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, - size.height);
    CGContextDrawImage(context, myRect, subImage);
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(subImage);
    
    //ROTATE LEFT 90 DEGREES
    UIImage * LandscapeImage = croppedImage;
    UIImage * PortraitImage = [[UIImage alloc] initWithCGImage: LandscapeImage.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationRight];
    
    return PortraitImage;
}

@end
