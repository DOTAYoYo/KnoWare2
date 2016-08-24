//
//  CameraSingleton.h
//  inSPECtor
//
//  Created by Jeremy Storer on 10/14/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraSingleton : NSObject{
AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;
AVCaptureDevice *inputDevice;
}

@property(nonatomic, retain) AVCaptureSession *session;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic,retain) AVCaptureDevice *inputDevice;

+(id)sharedManager;
@end
