//
//  selectedQuerySingleton.h
//  KnoWare
//
//  Created by Jeremy Storer on 2/17/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedQuerySingleton : NSObject{
    NSString *surveyID,*surveyType,*question,*choiceOne,*choiceTwo,*choiceThree,*choiceFour,*choiceFive,*choiceSix,*choiceOneHex,*choiceTwoHex,*choiceThreeHex,*choiceFourHex,*choiceFiveHex,*choiceSixHex,*responseMax,*responseMin,*stepSize,*linearHexOne,*linearHexTwo,*units;
}
@property (nonatomic,strong) NSString *surveyID,*surveyType;
@property (nonatomic,strong) NSString *question,*choiceOne,*choiceTwo,*choiceThree,*choiceFour,*choiceFive,*choiceSix,*choiceOneHex,*choiceTwoHex,*choiceThreeHex,*choiceFourHex,*choiceFiveHex,*choiceSixHex,*responseMax,*responseMin,*stepSize,*linearHexOne,*linearHexTwo,*units;
+(id)sharedManager;
@end
