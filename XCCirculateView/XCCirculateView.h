//
//  XCCirculateView.h
//  XCCirculateView
//
//  Created by xiangchao on 16/4/28.
//  Copyright © 2016年 STV. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XCCirculateViewScrollDirection){
    XCCirculateViewScrollDirectionNone,
    XCCirculateViewScrollDirectionLeft,
    XCCirculateViewScrollDirectionRight
};

typedef void (^CirculateViewItemDidClickBlock)(NSInteger clickedIndex);
@interface XCCirculateView : UIView
/**
 *展示图片的url地址
 */
@property (copy, nonatomic)NSArray<NSString *> *imageUrls;

/**
 *创建XCCirculateView的类方法
 *@param frame XCCirculateView的frame
 *@param imageUrls 展示图片的url地址
 */
+ (instancetype)circulateViewWithframe:(CGRect)frame imageUrls:(NSArray<NSString *> *) imageUrls;

/**
 *图片被点击时会调用该block，block的参数是被点击图片的索引
 */
@property (copy, nonatomic) CirculateViewItemDidClickBlock circulateViewItemDidClickBlock;

/**
 *是否开启自动轮播，默认不开起
 */
@property (assign, nonatomic) BOOL isAutoCirculate;
@end
