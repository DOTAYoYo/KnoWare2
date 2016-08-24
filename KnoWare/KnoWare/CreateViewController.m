//
//  CreateViewController.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/14/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import "CreateViewController.h"
#import "XLForm.h"
#import "XLFormViewController.h"
#import "HexColors.h"
#import "HRSampleColorPickerViewController2.h"

NSString *const kName = @"name";

@interface CreateViewController () <HRColorPickerViewControllerDelegate>

@property (nonatomic, strong) UIColor *color1;
@property (nonatomic, strong) UIColor *color2;
@property (nonatomic, strong) UIColor *color3;
@property (nonatomic, strong) UIColor *color4;
@property (nonatomic, strong) UIColor *color5;
@property (nonatomic, strong) UIColor *color6;
@property (nonatomic, strong) UIColor *linearColor1;
@property (nonatomic, strong) UIColor *linearColor2;
@property (nonatomic, strong) NSString *whichColor;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Create Query"];
    [form addFormSection:section];
    
    //Question
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"question" rowType:XLFormRowDescriptorTypeText title:@"Question:"];
    row.required = YES;
    [section addFormRow:row];
    
    // Selector Alert View Type
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"questionType" rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"Type:"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Numerical"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Multiple Choice"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Yes/No"]
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Numerical"];
    [section addFormRow:row];
    
    // Selector Alert View Gradient
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"sliderType" rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"Slider Type:"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Rainbow"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Linear Gradient"]
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Rainbow"];
    [section addFormRow:row];
    
    //units
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"units" rowType:XLFormRowDescriptorTypeText title:@"Units:"];
    row.required = YES;
    [section addFormRow:row];
    
    //minimum
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"min" rowType:XLFormRowDescriptorTypeNumber title:@"Min:"];
    row.required = YES;
    [section addFormRow:row];
    
    //maximum
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"max" rowType:XLFormRowDescriptorTypeNumber title:@"Max:"];
    row.required = YES;
    [section addFormRow:row];
    
    //step Size
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"stepSize" rowType:XLFormRowDescriptorTypeNumber title:@"Step Size:"];
    row.required = NO;
    [section addFormRow:row];
    
    //zip code
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"zipCode" rowType:XLFormRowDescriptorTypeNumber title:@"Zip Code:"];
    [section addFormRow:row];
    
    //link
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"linkToInstructions" rowType:XLFormRowDescriptorTypeText title:@"Link To Instructions:"];
    [section addFormRow:row];
    
    //allow images
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"allowImage" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Allow Image:"];
    [section addFormRow:row];
    
    //Submit Button Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"button" rowType:XLFormRowDescriptorTypeButton title:@"Submit"];
    [buttonRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
    buttonRow.action.formSelector = @selector(validateButton:);
    
    [section addFormRow:buttonRow];
    
    //buffer for button on bottom of screen
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    
    self.form = form;
    
    
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue{
    // super implmentation MUST be called
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
    if ([rowDescriptor.tag isEqualToString:@"questionType"]){
        [self.form removeFormRowWithTag:@"numberOfChoices"];
        [self.form removeFormRowWithTag:@"choice1"];
        [self.form removeFormRowWithTag:@"choice2"];
        [self.form removeFormRowWithTag:@"choice3"];
        [self.form removeFormRowWithTag:@"choice4"];
        [self.form removeFormRowWithTag:@"choice5"];
        [self.form removeFormRowWithTag:@"choice6"];
        [self.form removeFormRowWithTag:@"colorPickButton1"];
        [self.form removeFormRowWithTag:@"colorPickButton2"];
        [self.form removeFormRowWithTag:@"colorPickButton3"];
        [self.form removeFormRowWithTag:@"colorPickButton4"];
        [self.form removeFormRowWithTag:@"colorPickButton5"];
        [self.form removeFormRowWithTag:@"colorPickButton6"];
        [self.form removeFormRowWithTag:@"sliderType"];
        [self.form removeFormRowWithTag:@"units"];
        [self.form removeFormRowWithTag:@"min"];
        [self.form removeFormRowWithTag:@"max"];
        [self.form removeFormRowWithTag:@"stepSize"];
        [self.form removeFormRowWithTag:@"linearGradientButton1"];
        [self.form removeFormRowWithTag:@"linearGradientButton2"];
        //if Numerical
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(0)] == YES){
            XLFormRowDescriptor * newRow = [rowDescriptor copy];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"stepSize" rowType:XLFormRowDescriptorTypeNumber title:@"Step Size:"];
            newRow.required = NO;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"max" rowType:XLFormRowDescriptorTypeNumber title:@"Max:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"min" rowType:XLFormRowDescriptorTypeNumber title:@"Min:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"units" rowType:XLFormRowDescriptorTypeText title:@"Units:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            // Selector Alert View Gradient
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"sliderType" rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"Slider Type:"];
            newRow.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Rainbow"],
                                       [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Linear Gradient"]
                                       ];
            newRow.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Rainbow"];
            [self.form addFormRow:newRow afterRow:rowDescriptor];
        }
        
        
        //if Multiple Choice
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(1)] == YES){
            XLFormRowDescriptor * newRow = [rowDescriptor copy];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton3" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 3"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor3);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice3" rowType:XLFormRowDescriptorTypeText title:@"Choice 3:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton2" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 2"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor2);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice2" rowType:XLFormRowDescriptorTypeText title:@"Choice 2:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton1" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 1"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor1);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice1" rowType:XLFormRowDescriptorTypeText title:@"Choice 1:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"numberOfChoices" rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"Number of Choices:"];
            newRow.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"3"],
                                       [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"4"],
                                       [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"5"],
                                       [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"6"]
                                       ];
            newRow.value = [XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"3"];
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
        }
        
        //if Yes/No
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(2)] == YES){
            // XLFormRowDescriptor * newRow = [rowDescriptor copy];
            
            
        }
        
    }
    
    
    if ([rowDescriptor.tag isEqualToString:@"numberOfChoices"]){
        
        [self.form removeFormRowWithTag:@"choice1"];
        [self.form removeFormRowWithTag:@"choice2"];
        [self.form removeFormRowWithTag:@"choice3"];
        [self.form removeFormRowWithTag:@"choice4"];
        [self.form removeFormRowWithTag:@"choice5"];
        [self.form removeFormRowWithTag:@"choice6"];
        [self.form removeFormRowWithTag:@"colorPickButton1"];
        [self.form removeFormRowWithTag:@"colorPickButton2"];
        [self.form removeFormRowWithTag:@"colorPickButton3"];
        [self.form removeFormRowWithTag:@"colorPickButton4"];
        [self.form removeFormRowWithTag:@"colorPickButton5"];
        [self.form removeFormRowWithTag:@"colorPickButton6"];
        [self.form removeFormRowWithTag:@"linearGradientButton1"];
        [self.form removeFormRowWithTag:@"linearGradientButton2"];
        
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(0)] == YES){
            
            XLFormRowDescriptor * newRow = [rowDescriptor copy];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton3" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 3"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor3);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice3" rowType:XLFormRowDescriptorTypeText title:@"Choice 3:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton2" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 2"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor2);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice2" rowType:XLFormRowDescriptorTypeText title:@"Choice 2:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton1" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 1"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor1);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice1" rowType:XLFormRowDescriptorTypeText title:@"Choice 1:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
        }
        
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(1)] == YES){
            XLFormRowDescriptor * newRow = [rowDescriptor copy];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton4" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 4"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor4);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice4" rowType:XLFormRowDescriptorTypeText title:@"Choice 4:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton3" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 3"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor3);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice3" rowType:XLFormRowDescriptorTypeText title:@"Choice 3:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton2" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 2"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor2);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice2" rowType:XLFormRowDescriptorTypeText title:@"Choice 2:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton1" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 1"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor1);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice1" rowType:XLFormRowDescriptorTypeText title:@"Choice 1:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
        }
        
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(2)] == YES){
            XLFormRowDescriptor * newRow = [rowDescriptor copy];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton5" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 5"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor5);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice5" rowType:XLFormRowDescriptorTypeText title:@"Choice 5:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton4" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 4"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor4);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice4" rowType:XLFormRowDescriptorTypeText title:@"Choice 4:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton3" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 3"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor3);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice3" rowType:XLFormRowDescriptorTypeText title:@"Choice 3:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton2" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 2"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor2);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice2" rowType:XLFormRowDescriptorTypeText title:@"Choice 2:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton1" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 1"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor1);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice1" rowType:XLFormRowDescriptorTypeText title:@"Choice 1:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
        }
        
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(3)] == YES){
            XLFormRowDescriptor * newRow = [rowDescriptor copy];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton6" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 6"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor6);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice6" rowType:XLFormRowDescriptorTypeText title:@"Choice 6:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton5" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 5"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor5);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice5" rowType:XLFormRowDescriptorTypeText title:@"Choice 5:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton4" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 4"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor4);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice4" rowType:XLFormRowDescriptorTypeText title:@"Choice 4:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton3" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 3"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor3);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice3" rowType:XLFormRowDescriptorTypeText title:@"Choice 3:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton2" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 2"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor2);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice2" rowType:XLFormRowDescriptorTypeText title:@"Choice 2:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"colorPickButton1" rowType:XLFormRowDescriptorTypeButton title:@"Pick Color For 1"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColor1);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"choice1" rowType:XLFormRowDescriptorTypeText title:@"Choice 1:"];
            newRow.required = YES;
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
        }
    }
    if ([rowDescriptor.tag isEqualToString:@"sliderType"]){
        [self.form removeFormRowWithTag:@"linearGradientButton1"];
        [self.form removeFormRowWithTag:@"linearGradientButton2"];
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(1)] == YES){
            XLFormRowDescriptor * newRow = [rowDescriptor copy];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"linearGradientButton2" rowType:XLFormRowDescriptorTypeButton title:@"Right Side of Gradient Color"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColorGradient2);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
            
            newRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"linearGradientButton1" rowType:XLFormRowDescriptorTypeButton title:@"Left Side of Gradient Color"];
            [newRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            newRow.action.formSelector = @selector(pickColorGradient1);
            [self.form addFormRow:newRow afterRow:rowDescriptor];
        }
    }
}

- (void)validateButton:(XLFormDescriptor *)sender{
    int isValid = 1;
    
    NSArray * array = [self formValidationErrors];
    float minNum = 0.0,maxNum = 0.0,zipInput,stepSize = 0.0;
    XLFormRowDescriptor *row;
    NSString *question, *responseType, *units, *choiceOne, *choiceTwo, *choiceThree, *choiceFour, *choiceFive, *choiceSix,*choiceOneHex, *choiceTwoHex, *choiceThreeHex, *choiceFourHex, *choiceFiveHex, *choiceSixHex, *linearHex1, *linearHex2;
    
    row = [self.form formRowWithTag:@"question"];
    question = row.value;
    
    row = [self.form formRowWithTag:@"questionType"];
    if([[row.value valueData] isEqualToNumber:@(0)]){
        responseType = @"numerical";
        
        row = [self.form formRowWithTag:@"units"];
        units = row.value;
        row.required = YES;
        
        row = [self.form formRowWithTag:@"stepSize"];
        stepSize = [row.value floatValue];
        
        row = [self.form formRowWithTag:@"min"];
        minNum = [row.value floatValue];
        row.required = YES;
        
        row = [self.form formRowWithTag:@"max"];
        maxNum = [row.value floatValue];
        row.required = YES;
        //////////////////////
        row = [self.form formRowWithTag:@"choice1"];
        choiceOne = row.value;
        row.required = NO;
        
        row = [self.form formRowWithTag:@"choice2"];
        choiceTwo = row.value;
        row.required = NO;
        
        row = [self.form formRowWithTag:@"choice3"];
        choiceThree = row.value;
        row.required = NO;
    }
    if([[row.value valueData] isEqualToNumber:@(1)]){
        responseType = @"multipleChoice";
        
        row = [self.form formRowWithTag:@"choice1"];
        choiceOne = row.value;
        row.required = YES;
        
        row = [self.form formRowWithTag:@"choice2"];
        choiceTwo = row.value;
        row.required = YES;
        
        row = [self.form formRowWithTag:@"choice3"];
        choiceThree = row.value;
        row.required = YES;
        
        row = [self.form formRowWithTag:@"choice4"];
        choiceFour = row.value;
        
        row = [self.form formRowWithTag:@"choice5"];
        choiceFive = row.value;
        
        row = [self.form formRowWithTag:@"choice6"];
        choiceSix = row.value;
        ///////////////////////////
        row = [self.form formRowWithTag:@"units"];
        units = row.value;
        row.required = NO;
        
        row = [self.form formRowWithTag:@"min"];
        minNum = [row.value floatValue];
        row.required = NO;
        
        row = [self.form formRowWithTag:@"max"];
        maxNum = [row.value floatValue];
        row.required = NO;
    }
    if([[row.value valueData] isEqualToNumber:@(2)]){
        responseType = @"yesNo";
        
        row = [self.form formRowWithTag:@"choice1"];
        choiceOne = row.value;
        row.required = YES;
        
        row = [self.form formRowWithTag:@"choice2"];
        choiceTwo = row.value;
        row.required = YES;
        /////////////////////////
        row = [self.form formRowWithTag:@"choice3"];
        choiceThree = row.value;
        row.required = NO;
        
        row = [self.form formRowWithTag:@"units"];
        units = row.value;
        row.required = NO;
        
        row = [self.form formRowWithTag:@"min"];
        minNum = [row.value floatValue];
        row.required = NO;
        
        row = [self.form formRowWithTag:@"max"];
        maxNum = [row.value floatValue];
        row.required = NO;
    }
    
    
    row = [self.form formRowWithTag:@"zipCode"];
    zipInput = [row.value floatValue];
    
    
    if(self.color1 != nil)
        choiceOneHex = [[self hexStringFromColor:self.color1]substringFromIndex:1];
    if(self.color2 != nil)
        choiceTwoHex = [[self hexStringFromColor:self.color2] substringFromIndex:1];
    if(self.color3 != nil)
        choiceThreeHex = [[self hexStringFromColor:self.color3] substringFromIndex:1];
    if(self.color4 != nil)
        choiceFourHex = [[self hexStringFromColor:self.color4] substringFromIndex:1];
    if(self.color5 != nil)
        choiceFiveHex = [[self hexStringFromColor:self.color5] substringFromIndex:1];
    if(self.color6 != nil)
        choiceSixHex = [[self hexStringFromColor:self.color6] substringFromIndex:1];
    if(self.linearColor1 != nil)
        linearHex1 = [[self hexStringFromColor:self.linearColor1] substringFromIndex:1];
    if(self.linearColor2 != nil)
        linearHex2 = [[self hexStringFromColor:self.linearColor2] substringFromIndex:1];
    
    
    if([responseType  isEqualToString: @"numerical"]){
        if(minNum >= maxNum){
            isValid = 0;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"min must be less than max"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XLFormValidationStatus * validationStatus = [[obj userInfo] objectForKey:XLValidationStatusErrorKey];
        if ([validationStatus.rowDescriptor.tag isEqualToString:@"question"]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor orangeColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
            
        }
        if ([validationStatus.rowDescriptor.tag isEqualToString:@"units"]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor orangeColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
            
        }
        if ([validationStatus.rowDescriptor.tag isEqualToString:@"min"]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor orangeColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
        }
        if ([validationStatus.rowDescriptor.tag isEqualToString:@"max"]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor orangeColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
        }
        if ([validationStatus.rowDescriptor.tag isEqualToString:@"choice1"]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor orangeColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
        }
        if ([validationStatus.rowDescriptor.tag isEqualToString:@"choice2"]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor orangeColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
        }
        if ([validationStatus.rowDescriptor.tag isEqualToString:@"choice3"]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor orangeColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
        }
    }];
    
    [self deselectFormRow:sender];
    
    if([array count]==0 && isValid==1){
        
        // Create your request string with parameter name as defined in PHP file
        NSString *myRequestString = [NSString stringWithFormat:@"questionInput=%@&responseType=%@&unitsInput=%@&minInput=%f&maxInput=%f&stepInput=%f&zipInput=%f&choiceOneInput=%@&choiceTwoInput=%@&choiceThreeInput=%@&choiceFourInput=%@&choiceFiveInput=%@&choiceSixInput=%@&choiceOneHex=%@&choiceTwoHex=%@&choiceThreeHex=%@&choiceFourHex=%@&choiceFiveHex=%@&choiceSixHex=%@&linearHexOne=%@&linearHexTwo=%@",question,responseType,units,minNum,maxNum,stepSize,zipInput,choiceOne,choiceTwo,choiceThree,choiceFour,choiceFive,choiceSix,choiceOneHex,choiceTwoHex,choiceThreeHex,choiceFourHex,choiceFiveHex,choiceSixHex,linearHex1,linearHex2];
        
        //nslog(@"%@\n",myRequestString);
        
        // Create Data from request
        NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://agiledev.bgsu.edu/projects/knoware/iOS/createpoll.php"]];
        // set Request Type
        [request setHTTPMethod: @"POST"];
        // Set content-type
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        // Set Request Body
        [request setHTTPBody: myRequestData];
        // Now send a request and get Response
        //NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
        // Log Response
        //NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
        //nslog(@"%@",response);
        
        [self initializeForm];
        self.tabBarController.selectedIndex = 1;
    }
}

- (void)pickColor1{
    //nslog(@"click");
    HRSampleColorPickerViewController2 *controller;
    controller = [[HRSampleColorPickerViewController2 alloc] initWithColor:[UIColor redColor] fullColor:YES];
    controller.delegate = self;
    _whichColor = @"color1";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pickColor2{
    //nslog(@"click");
    HRSampleColorPickerViewController2 *controller;
    controller = [[HRSampleColorPickerViewController2 alloc] initWithColor:[UIColor redColor] fullColor:YES];
    controller.delegate = self;
    _whichColor = @"color2";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pickColor3{
    //nslog(@"click");
    HRSampleColorPickerViewController2 *controller;
    controller = [[HRSampleColorPickerViewController2 alloc] initWithColor:[UIColor redColor] fullColor:YES];
    controller.delegate = self;
    _whichColor = @"color3";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pickColor4{
    //nslog(@"click");
    HRSampleColorPickerViewController2 *controller;
    controller = [[HRSampleColorPickerViewController2 alloc] initWithColor:[UIColor redColor] fullColor:YES];
    controller.delegate = self;
    _whichColor = @"color4";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pickColor5{
    //nslog(@"click");
    HRSampleColorPickerViewController2 *controller;
    controller = [[HRSampleColorPickerViewController2 alloc] initWithColor:[UIColor redColor] fullColor:YES];
    controller.delegate = self;
    _whichColor = @"color5";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pickColor6{
    //nslog(@"click");
    HRSampleColorPickerViewController2 *controller;
    controller = [[HRSampleColorPickerViewController2 alloc] initWithColor:[UIColor redColor] fullColor:YES];
    controller.delegate = self;
    _whichColor = @"color6";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pickColorGradient1{
    //nslog(@"click");
    HRSampleColorPickerViewController2 *controller;
    controller = [[HRSampleColorPickerViewController2 alloc] initWithColor:[UIColor redColor] fullColor:YES];
    controller.delegate = self;
    _whichColor = @"colorGradient1";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pickColorGradient2{
    //nslog(@"click");
    HRSampleColorPickerViewController2 *controller;
    controller = [[HRSampleColorPickerViewController2 alloc] initWithColor:[UIColor redColor] fullColor:YES];
    controller.delegate = self;
    _whichColor = @"colorGradient2";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setSelectedColor:(UIColor *)color{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if([_whichColor isEqualToString:@"color1"]){
        self.color1 = color;
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"colorPickButton1"];
        [row.cellConfig setObject:color forKey:@"backgroundColor"];
        [self reloadFormRow:row];
    }
    else if([_whichColor isEqualToString:@"color2"]){
        self.color2 = color;
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"colorPickButton2"];
        [row.cellConfig setObject:color forKey:@"backgroundColor"];
        [self reloadFormRow:row];
    }
    else if([_whichColor isEqualToString:@"color3"]){
        self.color3 = color;
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"colorPickButton3"];
        [row.cellConfig setObject:color forKey:@"backgroundColor"];
        [self reloadFormRow:row];
    }
    else if([_whichColor isEqualToString:@"color4"]){
        self.color4 = color;
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"colorPickButton4"];
        [row.cellConfig setObject:color forKey:@"backgroundColor"];
        [self reloadFormRow:row];
    }
    else if([_whichColor isEqualToString:@"color5"]){
        self.color5 = color;
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"colorPickButton5"];
        [row.cellConfig setObject:color forKey:@"backgroundColor"];
        [self reloadFormRow:row];
    }
    else if([_whichColor isEqualToString:@"color6"]){
        self.color6 = color;
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"colorPickButton6"];
        [row.cellConfig setObject:color forKey:@"backgroundColor"];
        [self reloadFormRow:row];
    }
    else if([_whichColor isEqualToString:@"colorGradient1"]){
        self.linearColor1 = color;
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"linearGradientButton1"];
        [row.cellConfig setObject:color forKey:@"backgroundColor"];
        [self reloadFormRow:row];
    }
    else if([_whichColor isEqualToString:@"colorGradient2"]){
        self.linearColor2 = color;
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"linearGradientButton2"];
        [row.cellConfig setObject:color forKey:@"backgroundColor"];
        [self reloadFormRow:row];
    }
}

- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
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
