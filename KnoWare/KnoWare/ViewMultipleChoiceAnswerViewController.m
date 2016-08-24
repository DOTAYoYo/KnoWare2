//
//  ViewMultipleChoiceAnswerViewController.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "ViewMultipleChoiceAnswerViewController.h"
#import "SelectedQuerySingleton.h"
#import "HexColors.h"
#import <QuartzCore/QuartzCore.h>
#import "MBLocationManager.h"
@import CoreLocation;

@interface ViewMultipleChoiceAnswerViewController ()<NSURLConnectionDelegate>{
    SelectedQuerySingleton *selectedQuery;
    CLLocation *location;
    double longitude,latitude;
}

@end

@implementation ViewMultipleChoiceAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLocation:)
                                                 name:kMBLocationManagerNotificationLocationUpdatedName
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationManagerFailed:)
                                                 name:kMBLocationManagerNotificationFailedName
                                               object:nil];
    
    selectedQuery = [SelectedQuerySingleton sharedManager];
    
    self.questionLabel.text = selectedQuery.question;
    
    //set buttons
    [self.buttonOne setTitle:selectedQuery.choiceOne forState:UIControlStateNormal];
    [self.buttonOne setBackgroundColor:[UIColor hx_colorWithHexString:selectedQuery.choiceOneHex]];
    
    [self.buttonTwo setTitle:selectedQuery.choiceTwo forState:UIControlStateNormal];
    [self.buttonTwo setBackgroundColor:[UIColor hx_colorWithHexString:selectedQuery.choiceTwoHex]];
    
    [self.buttonThree setTitle:selectedQuery.choiceThree forState:UIControlStateNormal];
    [self.buttonThree setBackgroundColor:[UIColor hx_colorWithHexString:selectedQuery.choiceThreeHex]];
    if([selectedQuery.choiceThree  isEqual: @"(null)"]){
        [self.buttonThree setHidden:YES];
    }
    
    [self.buttonFour setTitle:selectedQuery.choiceFour forState:UIControlStateNormal];
    [self.buttonFour setBackgroundColor:[UIColor hx_colorWithHexString:selectedQuery.choiceFourHex]];
    if([selectedQuery.choiceFour isEqual: @"(null)"]){
        [self.buttonFour setHidden:YES];
    }
    
    [self.buttonFive setTitle:selectedQuery.choiceFive forState:UIControlStateNormal];
    [self.buttonFive setBackgroundColor:[UIColor hx_colorWithHexString:selectedQuery.choiceFiveHex]];
    if([selectedQuery.choiceFive isEqual: @"(null)"]){
        [self.buttonFive setHidden:YES];
    }
    
    [self.buttonSix setTitle:selectedQuery.choiceSix forState:UIControlStateNormal];
    [self.buttonSix setBackgroundColor:[UIColor hx_colorWithHexString:selectedQuery.choiceSixHex]];
    if([selectedQuery.choiceSix isEqual: @"(null)"]){
        [self.buttonSix setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)buttonOnePressed:(id)sender {
    [[self.buttonOne layer] setBorderWidth:2.0f];
    [[self.buttonOne layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonTwo layer] setBorderWidth:0.0f];
    [[self.buttonTwo layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonThree layer] setBorderWidth:0.0f];
    [[self.buttonThree layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFour layer] setBorderWidth:0.0f];
    [[self.buttonFour layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFive layer] setBorderWidth:0.0f];
    [[self.buttonFive layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonSix layer] setBorderWidth:0.0f];
    [[self.buttonSix layer] setBorderColor:[UIColor blackColor].CGColor];
    
    self.hexColorAnswer = selectedQuery.choiceOneHex;
    self.responseAnswer = selectedQuery.choiceOne;
}

- (IBAction)buttonTwoPressed:(id)sender {
    [[self.buttonOne layer] setBorderWidth:0.0f];
    [[self.buttonOne layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonTwo layer] setBorderWidth:2.0f];
    [[self.buttonTwo layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonThree layer] setBorderWidth:0.0f];
    [[self.buttonThree layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFour layer] setBorderWidth:0.0f];
    [[self.buttonFour layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFive layer] setBorderWidth:0.0f];
    [[self.buttonFive layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonSix layer] setBorderWidth:0.0f];
    [[self.buttonSix layer] setBorderColor:[UIColor blackColor].CGColor];
    
    self.hexColorAnswer = selectedQuery.choiceTwoHex;
    self.responseAnswer = selectedQuery.choiceTwo;
    
}

- (IBAction)buttonThreePressed:(id)sender {
    [[self.buttonOne layer] setBorderWidth:0.0f];
    [[self.buttonOne layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonTwo layer] setBorderWidth:0.0f];
    [[self.buttonTwo layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonThree layer] setBorderWidth:2.0f];
    [[self.buttonThree layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFour layer] setBorderWidth:0.0f];
    [[self.buttonFour layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFive layer] setBorderWidth:0.0f];
    [[self.buttonFive layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonSix layer] setBorderWidth:0.0f];
    [[self.buttonSix layer] setBorderColor:[UIColor blackColor].CGColor];
    
    self.hexColorAnswer = selectedQuery.choiceThreeHex;
    self.responseAnswer = selectedQuery.choiceThree;
    
}

- (IBAction)buttonFourPressed:(id)sender {
    [[self.buttonOne layer] setBorderWidth:0.0f];
    [[self.buttonOne layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonTwo layer] setBorderWidth:0.0f];
    [[self.buttonTwo layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonThree layer] setBorderWidth:0.0f];
    [[self.buttonThree layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFour layer] setBorderWidth:2.0f];
    [[self.buttonFour layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFive layer] setBorderWidth:0.0f];
    [[self.buttonFive layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonSix layer] setBorderWidth:0.0f];
    [[self.buttonSix layer] setBorderColor:[UIColor blackColor].CGColor];
    
    self.hexColorAnswer = selectedQuery.choiceFourHex;
    self.responseAnswer = selectedQuery.choiceFour;
    
}

- (IBAction)buttonFivePressed:(id)sender {
    [[self.buttonOne layer] setBorderWidth:0.0f];
    [[self.buttonOne layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonTwo layer] setBorderWidth:0.0f];
    [[self.buttonTwo layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonThree layer] setBorderWidth:0.0f];
    [[self.buttonThree layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFour layer] setBorderWidth:0.0f];
    [[self.buttonFour layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFive layer] setBorderWidth:2.0f];
    [[self.buttonFive layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonSix layer] setBorderWidth:0.0f];
    [[self.buttonSix layer] setBorderColor:[UIColor blackColor].CGColor];
    
    self.hexColorAnswer = selectedQuery.choiceFiveHex;
    self.responseAnswer = selectedQuery.choiceFive;
    
}

- (IBAction)buttonSixPressed:(id)sender {
    [[self.buttonOne layer] setBorderWidth:0.0f];
    [[self.buttonOne layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonTwo layer] setBorderWidth:0.0f];
    [[self.buttonTwo layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonThree layer] setBorderWidth:0.0f];
    [[self.buttonThree layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFour layer] setBorderWidth:0.0f];
    [[self.buttonFour layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonFive layer] setBorderWidth:0.0f];
    [[self.buttonFive layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[self.buttonSix layer] setBorderWidth:2.0f];
    [[self.buttonSix layer] setBorderColor:[UIColor blackColor].CGColor];
    
    self.hexColorAnswer = selectedQuery.choiceSixHex;
    self.responseAnswer = selectedQuery.choiceSix;
    
}

- (IBAction)submitActionButtonPressed:(id)sender {
    self.submitButton.enabled = NO;
    [self.submitButton setTitle:@"Submitting" forState:UIControlStateDisabled];
    
    NSURL *sendURL = [NSURL URLWithString:@"http://agile.bgsu.edu/KnoWare/iOS/uploadResponse.php"];
    
    NSMutableURLRequest *sendRequest = [NSMutableURLRequest requestWithURL:sendURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [sendRequest setHTTPMethod:@"POST"];
    
    [sendRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-Type"];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageThumbnail.image, 0.3);
    
    NSString *encodedString = [[self base64forData:imageData] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"id=%@&response=%@&longitude=%f&latitude=%f&hexcolor=%@&image=%@", selectedQuery.surveyID,self.responseAnswer,longitude,latitude,self.hexColorAnswer,encodedString];
    
    [sendRequest setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    serverConnection = [[NSURLConnection alloc] initWithRequest:sendRequest delegate:self];
    
    [serverConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
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
        
        //nslog(@"Response: %@", responseString);
        
        if ([responseString isEqualToString:@"Added\n"]) {
            
            /* Make something on success */
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:@"Answer has been submitted. Redirecting back to map page."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [[self navigationController] popViewControllerAnimated:YES];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error."
                                                            message:@"There was an error while submitting your answer. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            /* Make something else if not completed with success */
            //nslog(@"Error");
            self.submitButton.enabled = YES;
            [self.submitButton setTitle:@"Submit Answer" forState:UIControlStateNormal];
            
        }
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    /* Make something on failure */
    NSLog(@"Connection Failed");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

- (IBAction)attachPhotoButtonPressed:(id)sender {
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

- (IBAction)homeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"viewMultToHome" sender:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imageThumbnail setImage:image];    // "myImageView" name of any UIImageView.
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

@end
