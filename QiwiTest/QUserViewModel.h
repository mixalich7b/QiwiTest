//
//  QUserViewModel.h
//  QiwiTest
//
//  Created by Константин Тупицин on 11.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface QUserViewModel : NSObject

+ (instancetype)sharedInstance;

- (RACSignal *)usersUseCache:(BOOL)useCache;
- (RACSignal *)balancesWithUserId:(NSString *)userId;

@end
