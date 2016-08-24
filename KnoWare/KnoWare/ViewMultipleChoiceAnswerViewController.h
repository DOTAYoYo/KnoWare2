//
//  ViewMultipleChoiceAnswerViewController.h
//  KnoWare
//
//  Created by Jeremy Storer on 2/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface ViewMultipleChoiceAnswerViewController : UIViewController <UIImagePickerControllerDelegate,CLLocationManagerDelegate>{
    NSURLConnection *serverConnection;
    NSMutableData *returnData;
}
@property (strong,nonatomic) NSString *hexColorAnswer,*responseAnswer;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonSix;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageThumbnail;

- (IBAction)buttonOnePressed:(id)sender;
- (IBAction)buttonTwoPressed:(id)sender;
- (IBAction)buttonThreePressed:(id)sender;
- (IBAction)buttonFourPressed:(id)sender;
- (IBAction)buttonFivePressed:(id)sender;
- (IBAction)buttonSixPressed:(id)sender;
- (IBAction)submitActionButtonPressed:(id)sender;
- (IBAction)attachPhotoButtonPressed:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;

@end
