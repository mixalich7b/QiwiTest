//
//  QBalanceCell.m
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "QBalanceCell.h"
#import "QBalance.h"

#import "NSString+Bounds.h"

static const CGFloat marginLeft = 15.0;
static const CGFloat marginTop = 15.0;
static const CGFloat marginRight = 15.0;
static const CGFloat marginBottom = 15.0;

#define LABELS_FONT [UIFont boldSystemFontOfSize:20.0]

@interface QBalanceCell ()

@property (nonatomic, weak) UILabel *labelAmount;

@end

@implementation QBalanceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat labelWidth = self.frame.size.width - marginLeft - marginRight;
        UILabel *labelAmount = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, 0, labelWidth, self.frame.size.height)];
        if(labelAmount) {
            labelAmount.font = LABELS_FONT;
            labelAmount.numberOfLines = 0;
            labelAmount.lineBreakMode = NSLineBreakByWordWrapping;
            [self addSubview:labelAmount];
            self.labelAmount = labelAmount;
        }
    }
    return self;
}

- (void)setBalance:(QBalance *)balance {
    _balance = balance;
    NSString *amount = [_balance prettyAmount];
    self.labelAmount.text = amount;
    
    CGRect amountRect = self.labelAmount.frame;
    amountRect.origin.y = marginTop;
    amountRect.size.height = [amount qSizeWithFont:LABELS_FONT forWidth:amountRect.size.width].height;
    self.labelAmount.frame = amountRect;
}

+ (CGFloat)heightForBalance:(QBalance *)balance cellWidth:(CGFloat)width {
    width -= marginLeft + marginRight;
    CGFloat amountHeight = [[balance prettyAmount] qSizeWithFont:LABELS_FONT forWidth:width].height;
    return marginTop + amountHeight + marginBottom;
}

@end
