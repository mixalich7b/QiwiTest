//
//  NSString+Bounds.h
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Bounds)

- (CGSize)qSizeWithFont:(UIFont *)font;
- (CGSize)qSizeWithFont:(UIFont *)font forWidth:(CGFloat)width;
- (CGSize)qSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
