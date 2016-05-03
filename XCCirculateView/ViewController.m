//
//  ViewController.m
//  XCCirculateView
//
//  Created by xiangchao on 16/4/28.
//  Copyright © 2016年 STV. All rights reserved.
//

#import "ViewController.h"
#import "XCCirculateView.h"
#import "UIView+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *imageUrls = imageUrls = @[@"http://pic39.nipic.com/20140226/18071023_162553457000_2.jpg", @"http://pic36.nipic.com/20131217/6704106_233034463381_2.jpg", @"http://www.52ij.com/uploads/allimg/160317/0Q91622b-5.jpg"];
    XCCirculateView *circulateView = [XCCirculateView circulateViewWithframe:CGRectMake(0, 0, kScreenWidth, 140) imageUrls:imageUrls];
    circulateView.circulateViewItemDidClickBlock = ^(NSInteger index){
        NSLog(@"点击了第%ld个", index);
    };
    circulateView.isAutoCirculate = YES;
    [self.view addSubview:circulateView];
}


@end
