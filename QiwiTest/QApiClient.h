//
//  QApiClient.h
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class RACSignal;

extern NSString *const domain;

@interface QApiClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

- (RACSignal *)getPath:(NSString *)path parameters:(NSDictionary *)parameters;

@end
