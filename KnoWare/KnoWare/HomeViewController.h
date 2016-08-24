//
//  ViewController.h
//  KnoWare
//
//  Created by Jeremy Storer on 2/14/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
- (IBAction)createButtonPressed:(id)sender;
- (IBAction)viewButtonPressed:(id)sender;
- (IBAction)answerButtonPressed:(id)sender;
@end

