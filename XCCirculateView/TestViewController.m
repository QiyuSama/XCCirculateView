//
//  TestViewController.m
//  XCCirculateView
//
//  Created by xiangchao on 16/6/6.
//  Copyright © 2016年 STV. All rights reserved.
//

#import "TestViewController.h"
#import "ViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController
- (IBAction)onBtn:(id)sender {
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    NSLog(@"%@dealloc", NSStringFromClass([self class]));
}

@end
