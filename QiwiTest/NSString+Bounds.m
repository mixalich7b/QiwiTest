//
//  NSString+Bounds.m
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "NSString+Bounds.h"

@implementation NSString (Bounds)

- (CGSize)qSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    NSDictionary *attributes = @{ UITextAttributeFont : font};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    CGRect rect = [string boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       context:nil];
    return CGSizeMake(floorf(CGRectGetWidth(rect)) + 1, floorf(CGRectGetHeight(rect)) + 1);
}

- (CGSize)qSizeWithFont:(UIFont *)font forWidth:(CGFloat)width {
    return [self qSizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
}

- (CGSize)qSizeWithFont:(UIFont *)font {
    return [self qSizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

@end
