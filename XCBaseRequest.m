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
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end


@implementation XCBaseRequest


#pragma mark -
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        NSString *hostStr = [self getHost];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:hostStr]];
    }
    return _manager;
}

#pragma mark -
- (instancetype)init
{
    if (self = [super init]) {
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:[NSString stringWithFormat:@"%@_CancelRequest",NSStringFromClass([self class])] object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (NSString *)getHost
{
    return @"http://api.caipiao.163.com";
}

- (NSString *)getQuery
{
    return @"";
}

#pragma mark -
+ (void)requestData:(NSDictionary *)param modelClass:(_Nonnull Class)modelClass Success:(RequestSuccessBlock)succes failue:(RequestFailureBlock)failure
{
    
    XCBaseRequest *request = [self new];
    BaseRequestType methodType = [request getMethod];
    if (methodType == BaseRequestTypePost)
    {
        [request requestByPost:param success:succes failue:failure modelClass:modelClass];
    }
    else
    {//默认GET
        [request requestByGet:param success:succes failue:failure modelClass:modelClass];
    }
}

- (void)requestByGet:(NSDictionary *)param success:(RequestSuccessBlock)succes failue:(RequestFailureBlock)failure modelClass:(Class)modelClass
{
    NSString *query = [self getQuery];
    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:[self getDefaultParam]];
    [defaultParam addEntriesFromDictionary:param];
    
    [self.manager GET:query parameters:defaultParam progress:^(NSProgress * _Nonnull downloadProgress) {
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

}

- (void)requestByPost:(NSDictionary *)param success:(RequestSuccessBlock)succes failue:(RequestFailureBlock)failure modelClass:(Class)modelClass
{
    NSString *query = [self getQuery];
    NSMutableDictionary *defaultParam = [NSMutableDictionary dictionaryWithDictionary:[self getDefaultParam]];
    [defaultParam addEntriesFromDictionary:param];
    
    [self.manager POST:query parameters:defaultParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

}

#pragma mark -
- (void)cancelRequest
{
    [self.manager invalidateSessionCancelingTasks:YES];
    _manager = nil;
}

+ (void)cancelRequest
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@_CancelRequest",NSStringFromClass(self)] object:nil];
}
@end
