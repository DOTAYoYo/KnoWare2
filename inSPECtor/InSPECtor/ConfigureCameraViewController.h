//
//  ConfigureCameraViewController.h
//  InSPECtor
//
//  Created by Jeremy Storer on 3/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ConfigureCameraViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *frameForCapture;
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UISlider *ISOSlider;
@property (weak, nonatomic) IBOutlet UISlider *focusSlider;
@property (nonatomic) int *localExposure;
@property (nonatomic) int *localISO;
@property (nonatomic,retain) NSNumber *localFocus;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ISOLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;

- (IBAction)durationSliderMoved:(id)sender;
- (IBAction)ISOSliderMoved:(id)sender;
- (IBAction)focusSliderMoved:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)applyPressed:(id)sender;
@end
