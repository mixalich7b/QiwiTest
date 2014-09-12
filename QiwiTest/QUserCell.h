//
//  QUserCell.h
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QUser;

@interface QUserCell : UITableViewCell

@property (nonatomic, strong) QUser *user;

+ (CGFloat)heightForUser:(QUser *)user cellWidth:(CGFloat)width;

@end
