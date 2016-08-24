//
//  AppDelegate.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/14/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "AppDelegate.h"
#import "MBLocationManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize inspectorAnswer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    [GMSServices provideAPIKey:@"AIzaSyCPvAPSSeaSEttifEPSjfYwhmGxTSAK0Dw"];
    [[MBLocationManager sharedManager] startLocationUpdates:kMBLocationManagerModeStandardWhenInUse distanceFilter:kCLDistanceFilterNone accuracy:kCLLocationAccuracyBest ];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    NSDictionary *dict = [self parseQueryString:[url query]];
    //    NSLog(@"query dict: %@", dict);
    
    self.inspectorAnswer = [dict objectForKey:@"inspectorAnswer"];
    
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    [(UITabBarController *)self.window.rootViewController setSelectedIndex:1];
    
    return YES;

    
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
