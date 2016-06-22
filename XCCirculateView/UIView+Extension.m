//
//  UIView+Extension.m
//  XCCirculateView
//
//  Created by xiangchao on 16/4/28.
//  Copyright © 2016年 STV. All rights reserved.
//

#import "UIView+Extension.h"

static const CGFloat Arror_height = 10;
static const CGFloat CornoreRadius = 10;
@implementation UIView (Extension)

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (UIBezierPath *)getDrawPath

{
    
    CGRect rrect = self.bounds;
    
    
    
    CGFloat minx = CGRectGetMinX(rrect),
    
    midx = CGRectGetMidX(rrect),
    
    maxx = CGRectGetMaxX(rrect);
    
    CGFloat miny = CGRectGetMinY(rrect),
    
    
    
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(midx+Arror_height, maxy)];
    
    [path addLineToPoint:CGPointMake(midx, maxy+Arror_height)];
    
    
    [path addLineToPoint:CGPointMake(midx-Arror_height, maxy)];
    
    
    [path addLineToPoint:CGPointMake(minx + CornoreRadius, maxy)];
    
    [path addQuadCurveToPoint:CGPointMake(minx, maxy - CornoreRadius) controlPoint:CGPointMake(minx, maxy)];
    
    [path addLineToPoint:CGPointMake(minx, miny + CornoreRadius)];
    
    [path addQuadCurveToPoint:CGPointMake(minx + CornoreRadius, miny) controlPoint:CGPointMake(minx, miny)];
    
    [path addLineToPoint:CGPointMake(maxx - CornoreRadius, miny)];
    
    [path addQuadCurveToPoint:CGPointMake(maxx, miny + CornoreRadius) controlPoint:CGPointMake(maxx, miny)];
    
    [path addLineToPoint:CGPointMake(maxx, maxy - CornoreRadius)];
    
    [path addQuadCurveToPoint:CGPointMake(maxx - CornoreRadius, maxy) controlPoint:CGPointMake(maxx, maxy)];
    
    [path closePath];
    
    return path;
}

- (void)bubbleView
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = [self getDrawPath].CGPath;
    
    self.layer.mask = layer;
    
}

@end
