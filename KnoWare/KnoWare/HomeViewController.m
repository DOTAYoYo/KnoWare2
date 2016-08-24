//
//  ViewController.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/14/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "HomeViewController.h"
#import "MBLocationManager/MBLocationManager.h"
@import CoreLocation;

static NSString * const kShowTabSegueID = @"ShowTab";

@interface HomeViewController ()<UITabBarDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLocation:)
                                                 name:kMBLocationManagerNotificationLocationUpdatedName
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationManagerFailed:)
                                                 name:kMBLocationManagerNotificationFailedName
                                               object:nil];
    
    self.tabBar.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBar.hidden = NO;
}

-(void)locationManagerFailed:(NSNotification*)notification
{
    NSLog(@"Location manager failed");
}

-(void)changeLocation:(NSNotification*)notification
{
    CLLocation *location = [[MBLocationManager sharedManager] currentLocation];
    NSLog(@"Location changed to %f", location.coordinate.latitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"HEY");
    if([item.title  isEqual: @"Create"]){
        [self performSegueWithIdentifier:@"ShowTab"
                                  sender:@0];
    }
    if([item.title  isEqual: @"View"]){
        [self performSegueWithIdentifier:@"ShowTab"
                                  sender:@1];
    }
    if([item.title  isEqual: @"Answer"]){
        [self performSegueWithIdentifier:@"ShowTab"
                                  sender:@2];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"ShowTab"]) {
        NSNumber *indexToShow = sender;
        UITabBarController *tabBar = segue.destinationViewController;
        [tabBar setSelectedIndex:indexToShow.unsignedIntegerValue];
    }
    
}
- (IBAction)createButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ShowTab"
                              sender:@0];

}

- (IBAction)viewButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ShowTab"
                              sender:@1];

}

- (IBAction)answerButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ShowTab"
                              sender:@2];

}
@end
