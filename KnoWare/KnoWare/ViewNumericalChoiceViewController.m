//
//  ViewNumericalChoiceViewController.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "ViewNumericalChoiceViewController.h"
#import "HexColors.h"
#import <ChameleonFramework/Chameleon.h>
#import "SelectedQuerySingleton.h"
#import "AppDelegate.h"
#import "MBLocationManager.h"
@import QuartzCore;
@import CoreLocation;

@interface ViewNumericalChoiceViewController (){
    UIColor *linearColor1,*linearColor2;
    CGFloat red1,green1,blue1,alpha1;
    CGFloat red2,green2,blue2,alpha2;
    SelectedQuerySingleton *selectedQuery;
    NSString *responseAnswer,*hexColorAnswer;
    CLLocation *location;
    double longitude,latitude;
    NSURLConnection *serverConnection;
    NSMutableData *returnData;
}


@end

@implementation ViewNumericalChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLocation:)
                                                 name:kMBLocationManagerNotificationLocationUpdatedName
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationManagerFailed:)
                                                 name:kMBLocationManagerNotificationFailedName
                                               object:nil];
    // Do any additional setup after loading the view.
    selectedQuery = [SelectedQuerySingleton sharedManager];
    self.colorSlider.hidden = YES;
    self.colorSlider.maximumValue = 0.85;
    [self.numericalSlider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.numericalSlider setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.numericalSlider setMaximumValue:[selectedQuery.responseMax floatValue]];
    [self.numericalSlider setMinimumValue:[selectedQuery.responseMin floatValue]];
    [self.numericalSlider setValue:[selectedQuery.responseMin floatValue]];
    linearColor1 = [UIColor colorWithHexString:selectedQuery.linearHexOne];
    linearColor2 = [UIColor colorWithHexString:selectedQuery.linearHexTwo];
    if(![selectedQuery.linearHexOne  isEqual: @"(null)"]){
        self.rainbowGradientImage.hidden = YES;
        self.linearGradientView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.view.bounds andColors:@[linearColor1,linearColor2]];
    }
    if(appDelegate.inspectorAnswer){
        [self.numericalSlider setValue:[appDelegate.inspectorAnswer floatValue]];
        self.numberLabel.text = [NSString stringWithFormat:@"%.02f %@",[appDelegate.inspectorAnswer floatValue],selectedQuery.units];
        responseAnswer = [NSString stringWithFormat:@"%.02f %@",[appDelegate.inspectorAnswer floatValue], selectedQuery.units];
        if(self.rainbowGradientImage.hidden){
            [linearColor1 getRed:&(red1) green:&(green1) blue:&(blue1) alpha:&(alpha1)];
            [linearColor2 getRed:&(red2) green:&(green2) blue:&(blue2) alpha:&(alpha2)];
            float resultRed = red1 + [self.numericalSlider value] / [self.numericalSlider maximumValue] * (red2 - red1);
            float resultGreen = green1 + [self.numericalSlider value] / [self.numericalSlider maximumValue] * (green2 - green1);
            float resultBlue = blue1 + [self.numericalSlider value] / [self.numericalSlider maximumValue] * (blue2 - blue1);
            float resultAlpha = alpha1 + [self.numericalSlider value] / [self.numericalSlider maximumValue] * (alpha2 - alpha1);
            self.colorBoxView.backgroundColor = [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:resultAlpha];
            
        }else{
            self.colorBoxView.backgroundColor = [UIColor colorWithHue:(float)[self.colorSlider value] saturation:1.f brightness:1.f alpha:1.f];
            
        }
        hexColorAnswer = [self hexStringFromColor:self.colorBoxView.backgroundColor];
        
        
    }else{
        self.numberLabel.text = [NSString stringWithFormat:@"%.02f %@",[selectedQuery.responseMin floatValue],selectedQuery.units];
    }
    [self.questionLabel sizeToFit];
    self.questionLabel.text = selectedQuery.question;
}

- (IBAction)AttachPhotoButtonPressed:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    // image picker needs a delegate,
    [imagePickerController setDelegate:self];
    
    // Place image picker on the screen
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imageThumbnail setImage:image];    // "myImageView" name of any UIImageView.
}

- (IBAction)numberSliderMoved:(id)sender {
    
    if([selectedQuery.stepSize floatValue] > 0.0){
        float newStep = roundf((self.numericalSlider.value) / [selectedQuery.stepSize floatValue]);
        self.numericalSlider.value = newStep * [selectedQuery.stepSize floatValue];
    }
    
    if(self.rainbowGradientImage.hidden){
        [linearColor1 getRed:&(red1) green:&(green1) blue:&(blue1) alpha:&(alpha1)];
        [linearColor2 getRed:&(red2) green:&(green2) blue:&(blue2) alpha:&(alpha2)];
        float resultRed = red1 + [self.numericalSlider value] / [self.numericalSlider maximumValue] * (red2 - red1);
        float resultGreen = green1 + [self.numericalSlider value] / [self.numericalSlider maximumValue] * (green2 - green1);
        float resultBlue = blue1 + [self.numericalSlider value] / [self.numericalSlider maximumValue] * (blue2 - blue1);
        float resultAlpha = alpha1 + [self.numericalSlider value] / [self.numericalSlider maximumValue] * (alpha2 - alpha1);
        self.colorBoxView.backgroundColor = [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:resultAlpha];
        
    }else{
        [self.colorSlider setValue:(float)[self.numericalSlider value] * self.colorSlider.maximumValue/self.numericalSlider.maximumValue];
        self.colorBoxView.backgroundColor = [UIColor colorWithHue:(float)[self.colorSlider value] saturation:1.f brightness:1.f alpha:1.f];
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%.02f %@",[self.numericalSlider value], selectedQuery.units];
    hexColorAnswer = [self hexStringFromColor:self.colorBoxView.backgroundColor];
    responseAnswer = [NSString stringWithFormat:@"%.02f %@",[self.numericalSlider value], selectedQuery.units];
    
}

- (IBAction)SubmitAnswerButtonPressed:(id)sender {
    self.submitButton.enabled = NO;
    [self.submitButton setTitle:@"Submitting Answer..." forState:UIControlStateDisabled];
    
    NSURL *sendURL = [NSURL URLWithString:@"http://agile.bgsu.edu/KnoWare/iOS/uploadResponse.php"];
    
    NSMutableURLRequest *sendRequest = [NSMutableURLRequest requestWithURL:sendURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [sendRequest setHTTPMethod:@"POST"];
    
    [sendRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-Type"];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageThumbnail.image, 0.3);
    
    NSString *encodedString = [[self base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"id=%@&response=%@&longitude=%f&latitude=%f&hexcolor=%@&image=%@", selectedQuery.surveyID,responseAnswer,longitude,latitude,hexColorAnswer,encodedString];
    
    [sendRequest setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    serverConnection = [[NSURLConnection alloc] initWithRequest:sendRequest delegate:self];
    
    [serverConnection start];
}

- (IBAction)homeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"viewNumericalToHome" sender:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    returnData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [returnData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == serverConnection) {
        NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"Response: %@", responseString);
        
        if ([responseString isEqualToString:@"Added\n"]) {
            
            // toast with duration, title, and position
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success."
                                                            message:@"Your answer has been submitted, redirecting to map page."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self performSegueWithIdentifier: @"answerToMap" sender: self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error."
                                                            message:@"There was an error while submitting your answer. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            /* Make something else if not completed with success */
            //NSLog(@"Error");
            self.submitButton.enabled = YES;
            [self.submitButton setTitle:@"Submit Answer" forState:UIControlStateNormal];
            
        }
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    /* Make something on failure */
}

- (NSString*)base64forData:(NSData*) theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

-(void)locationManagerFailed:(NSNotification*)notification
{
    NSLog(@"Location manager failed");
}

-(void)changeLocation:(NSNotification*)notification
{
    location = [[MBLocationManager sharedManager] currentLocation];
    longitude = location.coordinate.longitude;
    latitude = location.coordinate.latitude;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
