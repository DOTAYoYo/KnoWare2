//
//  AppDelegate.h
//  KnoWare
//
//  Created by Jeremy Storer on 2/14/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *inspectorAnswer;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *inspectorAnswer;


@end

