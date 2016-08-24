//
//  QueryTableViewCell.h
//  KnoWare
//
//  Created by Jeremy Storer on 2/21/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellQuestion;
@property (weak, nonatomic) IBOutlet UILabel *cellID;

@end
