//
//  TestRequest.m
//  XCCirculateView
//
//  Created by xiangchao on 16/5/27.
//  Copyright © 2016年 STV. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest
- (NSString *)getQuery
{
    return @"http://api.utovr.com/sdkapi/a.png";
}

- (BaseRequestType)getMethod
{
    return BaseRequestTypePost;
}
@end
