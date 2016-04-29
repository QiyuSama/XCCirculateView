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
@property (copy, nonatomic)NSArray<NSString *> *imageUrls;
+ (instancetype)circulateViewWithframe:(CGRect)frame imageUrls:(NSArray<NSString *> *) imageUrls;
@property (copy, nonatomic) CirculateViewItemDidClickBlock circulateViewItemDidClickBlock;
@end
