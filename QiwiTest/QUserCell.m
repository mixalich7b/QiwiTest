//
//  QUserCell.m
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "QUserCell.h"
#import "QUser.h"
#import "NSString+Bounds.h"

#import <Masonry/Masonry.h>

const CGFloat marginLeft = 15.0;
const CGFloat marginTop = 15.0;
const CGFloat marginRight = 15.0;
const CGFloat marginBottom = 15.0;

static UIFont *labelsFont = nil;

@interface QUserCell ()

@property (nonatomic, weak) UILabel *labelName;
@property (nonatomic, weak) UILabel *labelSecondName;

@end

@implementation QUserCell

+ (void)load {
    labelsFont = [UIFont systemFontOfSize:17.0];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *labelName = [[UILabel alloc] init];
        if(labelName) {
            labelName.font = labelsFont;
            labelName.numberOfLines = 0;
            labelName.lineBreakMode = NSLineBreakByWordWrapping;
            [self addSubview:labelName];
            self.labelName = labelName;
            [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(marginTop);
                make.left.equalTo(self.mas_left).with.offset(marginLeft);
                make.right.equalTo(self.mas_right).with.offset(-marginRight);
                make.height.greaterThanOrEqualTo(@0);
            }];
        }
        UILabel *labelSecondName = [[UILabel alloc] init];
        if(labelSecondName) {
            labelSecondName.font = labelsFont;
            labelSecondName.numberOfLines = 0;
            labelSecondName.lineBreakMode = NSLineBreakByWordWrapping;
            [self addSubview:labelSecondName];
            self.labelSecondName = labelSecondName;
            [labelSecondName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(labelName.mas_bottom).with.offset(3.0);
                make.left.equalTo(self.mas_left).with.offset(marginLeft);
                make.right.equalTo(self.mas_right).with.offset(-marginRight);
                make.bottom.equalTo(self.mas_bottom).with.offset(-marginBottom);
                make.height.greaterThanOrEqualTo(@0);
            }];
        }
    }
    return self;
}

- (void)setUser:(QUser *)user {
    _user = user;
    NSString *name = [user.name length] > 0 ? user.name : @"-";
    NSString *secondName = [user.secondName length] > 0 ? user.secondName : @"-";
    self.labelName.text = name;
    self.labelSecondName.text = secondName;
}

+ (CGFloat)heightForUser:(QUser *)user cellWidth:(CGFloat)width {
    width -= marginLeft + marginRight;
    NSString *name = [user.name length] > 0 ? user.name : @"-";
    NSString *secondName = [user.secondName length] > 0 ? user.secondName : @"-";
    CGFloat nameHeight = [name qSizeWithFont:labelsFont forWidth:width].height;
    CGFloat secondNameHeight = [secondName qSizeWithFont:labelsFont forWidth:width].height;
    return marginTop + nameHeight + 3.0 + secondNameHeight + marginBottom;
}

@end
