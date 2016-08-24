//
//  Singleton.h
//  inSPECtor
//
//  Created by Jeremy Storer on 10/10/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface Singleton : NSObject{
    NSMutableArray *absorbance;
    NSMutableArray *smoothedAbsorbance;
    NSMutableArray *baseRedIntensity;
    NSMutableArray *baseGreenIntensity;
    NSMutableArray *baseBlueIntensity;
    NSMutableArray *baselightIntensity;
    NSMutableArray *baselightIntensity1;
    NSMutableArray *baselightIntensity2;
    NSMutableArray *baselightIntensity3;
    NSMutableArray *sampleRedIntensity;
    NSMutableArray *sampleGreenIntensity;
    NSMutableArray *sampleBlueIntensity;
    NSMutableArray *samplelightIntensity;
    NSMutableArray *samplelightIntensity1;
    NSMutableArray *samplelightIntensity2;
    NSMutableArray *samplelightIntensity3;
    NSMutableArray *locationArray;
    UIImage *baselightImage1;
    UIImage *baselightImage2;
    UIImage *baselightImage3;
    UIImage *samplelightImage1;
    UIImage *samplelightImage2;
    UIImage *samplelightImage3;
    NSNumber *isoValue;
    NSNumber *exposureValue;
    NSNumber *lensValue;
    NSString *selectedTest;
}
@property (nonatomic, retain) NSString *selectedTest;
@property (nonatomic, retain) NSNumber *exposureValue;
@property (nonatomic, retain) NSNumber *isoValue;
@property (nonatomic, retain) NSNumber *lensValue;
@property (nonatomic, retain) NSMutableArray *locationArray;

@property (nonatomic, retain) NSMutableArray *absorbance;
@property (nonatomic, retain) NSMutableArray *smoothedAbsorbance;

@property (nonatomic,retain) NSMutableArray *baseRedIntensity;
@property (nonatomic,retain) NSMutableArray *baseGreenIntensity;
@property (nonatomic,retain) NSMutableArray *baseBlueIntensity;

@property (nonatomic, retain) NSMutableArray *baselightIntensity;
@property (nonatomic, retain) NSMutableArray *baselightIntensity1;
@property (nonatomic, retain) NSMutableArray *baselightIntensity2;
@property (nonatomic, retain) NSMutableArray *baselightIntensity3;

@property (nonatomic, retain) NSMutableArray *sampleRedIntensity;
@property (nonatomic, retain) NSMutableArray *sampleGreenIntensity;
@property (nonatomic, retain) NSMutableArray *sampleBlueIntensity;

@property (nonatomic, retain) NSMutableArray *samplelightIntensity;
@property (nonatomic, retain) NSMutableArray *samplelightIntensity1;
@property (nonatomic, retain) NSMutableArray *samplelightIntensity2;
@property (nonatomic, retain) NSMutableArray *samplelightIntensity3;

@property (nonatomic, retain) UIImage *baselightImage1;
@property (nonatomic, retain) UIImage *baselightImage2;
@property (nonatomic, retain) UIImage *baselightImage3;

@property (nonatomic, retain) UIImage *samplelightImage1;
@property (nonatomic, retain) UIImage *samplelightImage2;
@property (nonatomic, retain) UIImage *samplelightImage3;

@property (nonatomic) NSInteger *cropStartLocation;
@property (nonatomic) NSInteger *cropEndLocation;

+(id)sharedManager;

@end
