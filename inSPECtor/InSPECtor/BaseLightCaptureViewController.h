//
//  BaseLightCaptureViewController.h
//  inSPECtor
//
//  Created by Jeremy Storer on 10/10/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BaseLightCaptureViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *frameForCapture;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UISlider *exposureSlider;
@property (weak, nonatomic) IBOutlet UILabel *exposureLabel;

- (IBAction)captureButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)sliderMoved:(id)sender;


@end
