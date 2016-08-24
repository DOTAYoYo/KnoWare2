//
//  ViewController.h
//  inSPECtor
//
//  Created by Jeremy Storer on 10/10/15.
//  Copyright (c) 2015 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *goButton;


- (IBAction)goButtonPressed:(id)sender;
@end

