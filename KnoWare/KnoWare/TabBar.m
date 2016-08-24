//
//  TabBar.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/17/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "TabBar.h"

@interface TabBar ()<UITabBarControllerDelegate>

@end

@implementation TabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Tab Bar Loaded");
    // Do any additional setup after loading the view.
    self.delegate = self;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"selected %lu",(unsigned long)tabBarController.selectedIndex);
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
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
