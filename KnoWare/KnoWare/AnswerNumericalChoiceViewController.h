//
//  AnswerNumericalChoiceViewController.h
//  KnoWare
//
//  Created by Jeremy Storer on 2/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerNumericalChoiceViewController : UIViewController<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *numericalSlider;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;
@property (weak, nonatomic) IBOutlet UIView *colorBoxView;
@property (weak, nonatomic) IBOutlet UIImageView *imageThumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *rainbowGradientImage;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *linearGradientView;

- (IBAction)AttachPhotoButtonPressed:(id)sender;
- (IBAction)numberSliderMoved:(id)sender;
- (IBAction)SubmitAnswerButtonPressed:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;
@end

