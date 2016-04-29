//
//  XCCirculateView.m
//  XCCirculateView
//
//  Created by xiangchao on 16/4/28.
//  Copyright © 2016年 STV. All rights reserved.
//

#import "XCCirculateView.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
@interface XCCirculateView () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *disPlayImageView;
@property (strong, nonatomic) UIImageView *backupImageview;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) XCCirculateViewScrollDirection direction;
@property (assign, nonatomic) NSInteger imageIndex;
@property (assign, nonatomic) NSInteger nextIndex;
@end

@implementation XCCirculateView


+ (instancetype)circulateViewWithframe:(CGRect)frame imageUrls:(NSArray<NSString *> *)imageUrls
{
    XCCirculateView *circulateView = [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
    circulateView.frame = frame;
    circulateView.imageUrls = imageUrls;
    return circulateView;
}

- (void)setImageUrls:(NSArray<NSString *> *)imageUrls
{
    _imageUrls = [imageUrls copy];
    [_disPlayImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrls firstObject]]];
    [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
    _pageControl.numberOfPages = _imageUrls.count;
//    _pageControl.currentPage = 0;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _scrollView.contentSize = CGSizeMake(3 * self.width, self.height);
    _backupImageview.width = _disPlayImageView.width = self.width;
    _backupImageview.height = _disPlayImageView.height = self.height;
    _disPlayImageView.origin = CGPointMake(self.width, 0);
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _disPlayImageView = [UIImageView new];
    _backupImageview = [UIImageView new];
    _disPlayImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backupImageview.contentMode = UIViewContentModeScaleAspectFill;
    _disPlayImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked)];
    [_disPlayImageView addGestureRecognizer:tap];
    [_scrollView addSubview:_disPlayImageView];
    [_scrollView addSubview:_backupImageview];
    _scrollView.delegate = self;
    
//    _pageControl = [UIPageControl new];
//    [self addSubview:_pageControl];
}

- (void)imageDidClicked
{
    if (_circulateViewItemDidClickBlock) {
        _circulateViewItemDidClickBlock(_imageIndex);
    }
    NSLog(@"%ld", _imageIndex);
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"direction"]) {
        if(change[NSKeyValueChangeNewKey] == change[NSKeyValueChangeOldKey]) return;
        XCCirculateViewScrollDirection direction = [change[NSKeyValueChangeNewKey] integerValue];
        if (direction == XCCirculateViewScrollDirectionLeft) {
            _backupImageview.origin = CGPointMake(2 * self.width, 0);
            _nextIndex = (_imageIndex + 1) % _imageUrls.count;
        }else{
            _backupImageview.origin = CGPointMake(0, 0);
            _nextIndex = _imageIndex - 1;
            if (_nextIndex < 0) {
                _nextIndex = _imageUrls.count - 1;
            }
        }
        [_backupImageview sd_setImageWithURL:[NSURL URLWithString:_imageUrls[_nextIndex]]];
    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"direction"];
}
#pragma scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x > _disPlayImageView.x) {
        
        if (_direction != XCCirculateViewScrollDirectionLeft) {
            [self setValue:@(XCCirculateViewScrollDirectionLeft) forKey:@"direction"];
        }
    }else if(_scrollView.contentOffset.x < _disPlayImageView.x){

        if (_direction != XCCirculateViewScrollDirectionRight) {
            [self setValue:@(XCCirculateViewScrollDirectionRight) forKey:@"direction"];
        }
        
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _direction = XCCirculateViewScrollDirectionNone;
    if (_scrollView.contentOffset.x == self.width) {//没有移动
        return;
    }
    _imageIndex = _nextIndex;
    _disPlayImageView.image = _backupImageview.image;
    [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
    _pageControl.currentPage = _imageIndex;
}


@end
