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

static const CGFloat marginLeft = 15.0;
static const CGFloat marginTop = 15.0;
static const CGFloat marginRight = 15.0;
static const CGFloat marginBottom = 15.0;

#define LABELS_FONT [UIFont systemFontOfSize:17.0]

@interface QUserCell ()

@property (nonatomic, weak) UILabel *labelName;
@property (nonatomic, weak) UILabel *labelSecondName;

@end

@implementation QUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat labelWidth = self.frame.size.width - marginLeft - marginRight;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, 0, labelWidth, self.frame.size.height)];
        if(labelName) {
            labelName.font = LABELS_FONT;
            labelName.numberOfLines = 0;
            labelName.lineBreakMode = NSLineBreakByWordWrapping;
            [self addSubview:labelName];
            self.labelName = labelName;
        }
        UILabel *labelSecondName = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, 0, labelWidth, self.frame.size.height)];
        if(labelSecondName) {
            labelSecondName.font = LABELS_FONT;
            labelSecondName.numberOfLines = 0;
            labelSecondName.lineBreakMode = NSLineBreakByWordWrapping;
            [self addSubview:labelSecondName];
            self.labelSecondName = labelSecondName;
        }
    }
    return self;
}

- (void)setUser:(QUser *)user {
    _user = user;
    NSString *name = [user.name length] > 0 ? user.name : nil;
    NSString *secondName = [user.secondName length] > 0 ? user.secondName : nil;
    self.labelName.text = name;
    self.labelSecondName.text = secondName;
    
    CGRect nameRect = self.labelName.frame;
    CGRect secondNameRect = self.labelSecondName.frame;
    if(name) {
        if(secondName) {
            nameRect.origin.y = marginTop;
            nameRect.size.height = [name qSizeWithFont:LABELS_FONT forWidth:nameRect.size.width].height;
        } else {
            nameRect.origin.y = 0;
            nameRect.size.height = self.frame.size.height;
        }
    }
    if(secondName) {
        if(name) {
            secondNameRect.origin.y = CGRectGetMaxY(nameRect) + 3.0;
            secondNameRect.size.height = [secondName qSizeWithFont:LABELS_FONT forWidth:secondNameRect.size.width].height;
        } else {
            secondNameRect.origin.y = 0;
            secondNameRect.size.height = self.frame.size.height;
        }
    }
    self.labelName.frame = nameRect;
    self.labelSecondName.frame = secondNameRect;
}

+ (CGFloat)heightForUser:(QUser *)user cellWidth:(CGFloat)width {
    width -= marginLeft + marginRight;
    CGFloat nameHeight = [user.name length] > 0 ? [user.name qSizeWithFont:LABELS_FONT forWidth:width].height : 0;
    CGFloat secondNameHeight = [user.secondName length] > 0 ? [user.secondName qSizeWithFont:LABELS_FONT forWidth:width].height : 0;
    CGFloat space = (nameHeight > 0 && secondNameHeight > 0) ? 3.0 : 0;
    return marginTop + nameHeight + space + secondNameHeight + marginBottom;
}

@end
