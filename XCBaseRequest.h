//
//  BaseRequest.h
//  XCNetWork
//
//  Created by xiangchao on 16/1/25.
//  Copyright © 2016年 STV. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class AFHTTPSessionManager, XCBaseRequest;

typedef NS_ENUM(NSInteger, BaseRequestType){
    BaseRequestTypeGet = 0,
    BaseRequestTypePost
};
typedef void (^RequestSuccessBlock)(XCBaseRequest *request);
typedef void (^RequestFailureBlock)(NSError *error);

@interface XCBaseRequest : NSObject


/**
 * 需要根据服务器的字段手动解析
 */
@property (nonatomic, assign, readonly) NSInteger totalCount;
@property (nonatomic, strong, readonly) id resultModel;

/**
 * 发送请求
 */
+ (void)requestData:(NSDictionary *)param modelClass:(_Nonnull Class)modelClass Success:(RequestSuccessBlock) succes failue:(RequestFailureBlock) failure;

+ (void)cancelRequest;

/**
 * 获取服务器地址
 */
- (NSString *)getHost;

/**
 * 获取相对地址
 */
- (NSString *)getQuery;

/**
 * 获取请求参数
 */
- (NSDictionary *)getDefaultParam;

/**
 * 获取请求方法，默认为GET
 */
- (BaseRequestType)getMethod;
NS_ASSUME_NONNULL_END
@end
