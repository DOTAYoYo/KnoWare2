//
//  selectedQuerySingleton.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/17/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "SelectedQuerySingleton.h"

@implementation SelectedQuerySingleton
@synthesize surveyID,surveyType,question,choiceOne,choiceTwo,choiceThree,choiceFour,choiceFive,choiceSix,choiceOneHex,choiceTwoHex,choiceThreeHex,choiceFourHex,choiceFiveHex,choiceSixHex,responseMax,responseMin,stepSize,linearHexTwo,linearHexOne,units;

+ (id)sharedManager {
    static SelectedQuerySingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        surveyID = NULL;
        surveyType = NULL;
        question = NULL;
        choiceOne = NULL;
        choiceTwo = NULL;
        choiceThree = NULL;
        choiceFour = NULL;
        choiceFive = NULL;
        choiceSix = NULL;
        choiceOneHex = NULL;
        choiceTwoHex = NULL;
        choiceThreeHex = NULL;
        choiceFourHex = NULL;
        choiceFiveHex = NULL;
        choiceSixHex = NULL;
        responseMin = NULL;
        responseMax = NULL;
        linearHexOne = NULL;
        linearHexTwo = NULL;
        stepSize = NULL;
        units = NULL;
    }
    return self;
}

@end
