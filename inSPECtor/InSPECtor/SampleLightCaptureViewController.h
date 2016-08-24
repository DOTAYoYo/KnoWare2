//
//  SampleLightCaptureViewController.h
//  inSPECtor
//
//  Created by Jeremy Storer on 10/12/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SampleLightCaptureViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *frameForCapture;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

- (IBAction)captureButtonPressed:(id)sender;
@end
