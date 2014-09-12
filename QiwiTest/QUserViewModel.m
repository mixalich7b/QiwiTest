//
//  QUserViewModel.m
//  QiwiTest
//
//  Created by Константин Тупицин on 11.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "QUserViewModel.h"
#import "QUser.h"
#import "QApiClient.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveNSXMLParser/NSXMLParser+ReactiveCocoa.h>
#import <EGOCache/EGOCache.h>

static NSString *usersCacheKey = @"usersCacheKey";

NS_ENUM(NSInteger, QError) {
    QParsingError = -1,
};

@implementation QUserViewModel

+ (instancetype)sharedInstance {
    static QUserViewModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (RACSignal *)usersUseCache:(BOOL)useCache {
    return [[RACSignal startLazilyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] block:^void(id<RACSubscriber> usersSubscriber) {
        NSArray *users = nil;
        if(useCache) {
            users = (NSArray *)[[EGOCache globalCache] objectForKey:usersCacheKey];
        }
        if([users isKindOfClass:[NSArray class]] && [users count] > 0) {
            [usersSubscriber sendNext:users];
            [usersSubscriber sendCompleted];
        } else {
            [[[[QApiClient sharedClient] getPath:@"/test" parameters:@{}] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]]
             subscribeNext:^(NSData *response) {
                 [[self parseResponseFromXML:response]
                  subscribeNext:^(NSArray *users) {
                      [[EGOCache globalCache] setObject:users forKey:usersCacheKey];
                      [usersSubscriber sendNext:users];
                  } error:^(NSError *error) {
                      [usersSubscriber sendError:error];
                  } completed:^{
                      [usersSubscriber sendCompleted];
                  }];
            } error:^(NSError *error) {
                [usersSubscriber sendError:error];
            }];
        }
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)parseResponseFromXML:(NSData *)rawXML {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [[RACScheduler currentScheduler] schedule:^{
            [[NSXMLParser rac_dictionaryFromData:rawXML elementFilter:nil] subscribeNext:^(NSDictionary *responseDict) {
                @try {
                    NSDictionary *response = responseDict[@"response"];
                    if(![self validateResponse:response]) {
                        @throw [NSException exceptionWithName:@"Error" reason:@"Bad response" userInfo:nil];
                    }
                    NSInteger errorCode = [response[@"result-code"][@"text"] integerValue];
                    if(errorCode == 0) {
                        NSArray *userDicts = response[@"users"][@"user"];
                        NSArray *users = [[[userDicts.rac_sequence map:^id(NSDictionary *userDict) {
                            return [self parseUserFromDict:userDict];
                        }] filter:^BOOL(id value) {
                            return [value isKindOfClass:[QUser class]];
                        }] array];
                        [subscriber sendNext:users];
                    } else {
                        [subscriber sendError:[NSError errorWithDomain:domain code:errorCode userInfo:@{NSLocalizedDescriptionKey: response[@"result-code"][@"message"]}]];
                    }
                } @catch(...) {
                    [subscriber sendError:[NSError errorWithDomain:domain code:QParsingError userInfo:@{NSLocalizedDescriptionKey: @"Ошибка при получении данных с сервера. Попробуйте ещё раз."}]];
                }
            } error:^(NSError *error) {
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
        }];
    }];
}

- (BOOL)validateResponse:(NSDictionary *)response {
    if([response isKindOfClass:[NSDictionary class]] == NO || response[@"result-code"] == nil || [response[@"users"][@"user"] isKindOfClass:[NSArray class]] == NO) {
        return NO;
    }
    return YES;
}

- (QUser *)parseUserFromDict:(NSDictionary *)dict {
    NSError *parsingError = nil;
    QUser *user = [MTLJSONAdapter modelOfClass:[QUser class] fromJSONDictionary:dict error:&parsingError];
    if(parsingError != nil) {
        NSLog(@"%@", [parsingError localizedDescription]);
    }
    return user;
}

@end
