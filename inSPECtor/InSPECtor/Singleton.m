//
//  Singleton.m
//  inSPECtor
//
//  Created by Jeremy Storer on 10/10/15.
//  Copyright © 2015 Jeremy Storer. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

@synthesize baselightImage1,baselightImage2,baselightImage3;
@synthesize samplelightImage1,samplelightImage2,samplelightImage3;
@synthesize baselightIntensity,baselightIntensity1,baselightIntensity2,baselightIntensity3;
@synthesize samplelightIntensity,samplelightIntensity1,samplelightIntensity2,samplelightIntensity3;
@synthesize absorbance;
@synthesize cropEndLocation,cropStartLocation;
@synthesize locationArray;
@synthesize baseBlueIntensity,baseRedIntensity,baseGreenIntensity,sampleRedIntensity,sampleBlueIntensity,sampleGreenIntensity,isoValue,exposureValue,lensValue,smoothedAbsorbance,selectedTest;


+(id)sharedManager{
    static Singleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

-(id)init {
    if (self = [super init]){
        exposureValue = [NSNumber numberWithInteger:100];
        lensValue = [NSNumber numberWithFloat:0.5];
        isoValue = [NSNumber numberWithInteger:222];
        baselightImage1 = [[UIImage alloc] init];
        baselightImage2 = [[UIImage alloc] init];
        baselightImage3 = [[UIImage alloc] init];
        
        samplelightImage1 = [[UIImage alloc] init];
        samplelightImage2 = [[UIImage alloc] init];
        samplelightImage3 = [[UIImage alloc] init];
        
        absorbance = [[NSMutableArray alloc] init];
        smoothedAbsorbance = [[NSMutableArray alloc] init];
        
        baseGreenIntensity = [[NSMutableArray alloc] init];
        baseBlueIntensity = [[NSMutableArray alloc] init];
        baseRedIntensity = [[NSMutableArray alloc] init];
        
        baselightIntensity = [[NSMutableArray alloc] init];
        baselightIntensity1 = [[NSMutableArray alloc] init];
        baselightIntensity2 = [[NSMutableArray alloc] init];
        baselightIntensity3 = [[NSMutableArray alloc] init];
        
        samplelightIntensity = [[NSMutableArray alloc] init];
        samplelightIntensity1 = [[NSMutableArray alloc] init];
        samplelightIntensity2 = [[NSMutableArray alloc] init];
        samplelightIntensity3 = [[NSMutableArray alloc] init];
        
        sampleGreenIntensity = [[NSMutableArray alloc] init];
        sampleBlueIntensity = [[NSMutableArray alloc] init];
        sampleRedIntensity = [[NSMutableArray alloc] init];
        
        locationArray = [[NSMutableArray alloc] init];
        
        selectedTest = [[NSString alloc] init];
        
        
        
    }
    return self;
}

@end
