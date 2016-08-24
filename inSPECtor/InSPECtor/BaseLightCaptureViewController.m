//
//  BaseLightCaptureViewController.m
//  inSPECtor
//
//  Created by Jeremy Storer on 10/10/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseLightCaptureViewController.h"
#import "Singleton.h"
#import "CameraSingleton.h"

@interface BaseLightCaptureViewController ()

@end
AVCaptureDevice *inputDevice3;
AVCaptureSession *session3;
AVCaptureStillImageOutput *stillImageOutput3;
@implementation BaseLightCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    Singleton *singleton = [Singleton sharedManager];
    // Do any additional setup after loading the view.
    float ISO = [singleton.isoValue integerValue];
    int DURATION = [singleton.exposureValue integerValue];
    
    self.captureButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.captureButton.layer.borderWidth = 1.0;
    self.captureButton.layer.cornerRadius = 10.0;
    
    self.nextButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.nextButton.layer.borderWidth = 1.0;
    self.nextButton.layer.cornerRadius = 10.0;
    self.nextButton.enabled = false;
    
    self.backButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.backButton.layer.borderWidth = 1.0;
    self.backButton.layer.cornerRadius = 10.0;
    
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.cornerRadius = 10.0;
    
    session3 = [[AVCaptureSession alloc] init];
    [session3 beginConfiguration];
    [session3 setSessionPreset:AVCaptureSessionPresetPhoto];
    [session3 commitConfiguration];
    
    inputDevice3 = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [inputDevice3 lockForConfiguration:nil];
    
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice3 error:&error];
    
    if ([session3 canAddInput:deviceInput]) {
        [session3 addInput:deviceInput];
    }
    
    [inputDevice3 setVideoZoomFactor:2.0f];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session3];
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewLayer.frame = self.frameForCapture.bounds;
    [self.frameForCapture.layer addSublayer:previewLayer];
    
    UIView *view = [self frameForCapture];
    CALayer *rootLayer = [view layer];
    [rootLayer setMasksToBounds:YES];
    
    CGRect frame = self.frameForCapture.bounds;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput3 = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [stillImageOutput3 setOutputSettings:outputSettings];
    
    [session3 addOutput:stillImageOutput3];
    
    [session3 startRunning];
    [inputDevice3 setFocusModeLockedWithLensPosition:[singleton.lensValue floatValue] completionHandler:nil];
    [inputDevice3 setExposureModeCustomWithDuration:CMTimeMake(1,DURATION) ISO:ISO completionHandler:nil];
    [inputDevice3 unlockForConfiguration];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    [session3 removeOutput:cameraSingleton.stillImageOutput];
    [session3 stopRunning];

}
- (void)capturePhoto {
    Singleton *singleton = [Singleton sharedManager];
    CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in stillImageOutput3.connections) {
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
    
    [stillImageOutput3 captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
            singleton.baselightImage1 = image;
            self.imageView.image = singleton.baselightImage1;
        }
    }];
    [stillImageOutput3 captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
                image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
            singleton.baselightImage2 = image;
        }
    }];
    [stillImageOutput3 captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL){
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            image = [self cropImage:image to:CGRectMake(image.size.width/2+320, 0, 320, image.size.width) andScaleTo:CGSizeMake(306, image.size.width)];
            singleton.baselightImage3 = image;
        }
    }];
    
    self.nextButton.enabled = YES;

}

- (IBAction)captureButtonPressed:(id)sender {
    Singleton *singleton = [Singleton sharedManager];
    [self capturePhoto];
    singleton = [Singleton sharedManager];
    self.imageView.image = singleton.baselightImage1;
    self.nextButton.enabled = true;
}

- (IBAction)backButtonPressed:(id)sender {
    CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    [session3 stopRunning];
    [session3 removeOutput:stillImageOutput3];
    
}

- (IBAction)nextButtonPressed:(id)sender {
    CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    [session3 stopRunning];
    [session3 removeOutput:stillImageOutput3];
}

- (IBAction)sliderMoved:(id)sender {
     CameraSingleton *cameraSingleton = [CameraSingleton sharedManager];
    [inputDevice3 setExposureModeCustomWithDuration:CMTimeMake(1,self.exposureSlider.value) ISO:200 completionHandler:nil];
    self.exposureLabel.text = [NSString stringWithFormat:@"%f",1/self.exposureSlider.value];
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
