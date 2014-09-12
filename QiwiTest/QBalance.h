//
//  QBalance.h
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface QBalance : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *amount;

- (NSString *)prettyAmount;

@end
