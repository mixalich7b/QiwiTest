//
//  QBalanceCell.h
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBalance;

@interface QBalanceCell : UITableViewCell

@property (nonatomic, strong) QBalance *balance;

+ (CGFloat)heightForBalance:(QBalance *)user cellWidth:(CGFloat)width;

@end
