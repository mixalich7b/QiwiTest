//
//  QBalance.m
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "QBalance.h"

@implementation QBalance

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

- (NSString *)prettyAmount {
    if([self.currency isEqualToString:@"RUB"]) {
        return [NSString stringWithFormat:@"%@ р.", self.amount];
    } else if([self.currency isEqualToString:@"USD"]) {
        return [NSString stringWithFormat:@"$%@", self.amount];
    } else if([self.currency isEqualToString:@"EUR"]) {
        return [NSString stringWithFormat:@"€%@", self.amount];
    } else {
        return [NSString stringWithFormat:@"%@: %@", self.currency, self.amount];
    }
}

@end
