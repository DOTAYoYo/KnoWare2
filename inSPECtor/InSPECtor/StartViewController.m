//
//  ViewController.m
//  inSPECtor
//
//  Created by Jeremy Storer on 10/10/15.
//  Copyright (c) 2015 Jeremy Storer. All rights reserved.
//

#import "StartViewController.h"
#import "Singleton.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.goButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.goButton.layer.borderWidth = 1.0;
    self.goButton.layer.cornerRadius = 10.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goButtonPressed:(id)sender {
}
@end
