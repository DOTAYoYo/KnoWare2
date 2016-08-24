//
//  CameraSingleton.m
//  inSPECtor
//
//  Created by Jeremy Storer on 10/14/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import "CameraSingleton.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraSingleton
@synthesize session,stillImageOutput;
+(id)sharedManager{
    static CameraSingleton *cameraSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cameraSingleton = [[self alloc] init];
    });
    return cameraSingleton;
}

-(id)init{
     if (self = [super init]){
    session = [[AVCaptureSession alloc] init];
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
   // inputDevice = [[AVCaptureDevice alloc]init];
     }
    
    return self;
}
@end
