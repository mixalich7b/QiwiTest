//
//  QApiClient.m
//  QiwiTest
//
//  Created by Константин Тупицин on 12.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "QApiClient.h"

#import <EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static NSString *const serviceBaseURL = @"http://je.su";
NSString *const domain = @"je.su";

@implementation QApiClient

+ (instancetype)sharedClient {
    static QApiClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] initWithBaseURL:
                    [NSURL URLWithString:serviceBaseURL]];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSSet *acceptableContentTypes = instance.responseSerializer.acceptableContentTypes;
        instance.responseSerializer.acceptableContentTypes = [acceptableContentTypes setByAddingObject:@"text/xml"];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    return instance;
}

- (RACSignal *)getPath:(NSString *)path parameters:(NSDictionary *)parameters {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        AFHTTPRequestOperation *operation = [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

@end
