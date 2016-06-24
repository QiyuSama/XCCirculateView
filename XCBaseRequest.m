//
//  BaseRequest.m
//  XCNetWork
//
//  Created by xiangchao on 16/1/25.
//  Copyright © 2016年 STV. All rights reserved.
//

#import "XCBaseRequest.h"
#import "AFNetworking.h"
#import "MJExtension.h"


@interface XCBaseRequest ()
@property (strong, nonatomic) NSURLSessionTask *task;
@end

static AFHTTPSessionManager *_manager = nil;

@implementation XCBaseRequest

#pragma mark -
- (instancetype)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *hostStr = [self getHost];
            _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:hostStr]];
            _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        });
    }
    return self;
}

#pragma mark -
- (BaseRequestType)getMethod
{
    return BaseRequestTypeGet;
}

- (NSDictionary *)getDefaultParam
{
    return @{};
}

/**
 * 获取服务器地址
 */
- (NSString *)getHost
{
    return @"";
}

- (NSString *)getQuery
{
    return @"";
}

#pragma mark -
+ (void)requestData:(NSDictionary *)param modelClass:(_Nonnull Class)modelClass Success:(RequestSuccessBlock)succes failue:(RequestFailureBlock)failure
{
    
    XCBaseRequest *request = [self new];
    [request cancelRequest];
    
    BaseRequestType methodType = [request getMethod];
    if (methodType == BaseRequestTypePost)
    {
        request.task = [request requestByPost:param success:succes failue:failure modelClass:modelClass];
    }
    else
    {//默认GET
        request.task = [request requestByGet:param success:succes failue:failure modelClass:modelClass];
    }
    
}

- (NSURLSessionTask *)requestByGet:(NSDictionary *)param success:(RequestSuccessBlock)succes failue:(RequestFailureBlock)failure modelClass:(Class)modelClass
{
    NSString *query = [self getQuery];
    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:[self getDefaultParam]];
    [defaultParam addEntriesFromDictionary:param];
    
    NSURLSessionTask *task = [_manager GET:query parameters:defaultParam progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id model = [modelClass mj_objectWithKeyValues:responseObject];
        _resultModel = model;
        //TODO 解析totalCount
        if(succes)
        {
            succes(self);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (failure) {
            failure(error);
        }
    }];

    return task;
}

- (NSURLSessionTask *)requestByPost:(NSDictionary *)param success:(RequestSuccessBlock)succes failue:(RequestFailureBlock)failure modelClass:(Class)modelClass
{
    NSString *query = [self getQuery];
    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:[self getDefaultParam]];
    [defaultParam addEntriesFromDictionary:param];
    
    NSURLSessionTask *task = [_manager POST:query parameters:defaultParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id model = [modelClass mj_objectWithKeyValues:responseObject];

        _resultModel = model;
        //TODO 解析totalCount
        if(succes)
        {
            succes(self);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    return task;
}

#pragma mark -
- (void)cancelRequest
{
    [self.task cancel];
    self.task = nil;
}


@end
