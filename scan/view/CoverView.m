//
//  CoverView.m
//  yinyue
//
//  Created by 陈鑫荣 on 2017/5/3.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "CoverView.h"

@implementation CoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置 背景为clear
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}
-(void)drawRect:(CGRect)rect{

    [[UIColor colorWithWhite:0 alpha:0.2] setFill];
    //半透明区域
    UIRectFill(rect);
    
    //透明的区域
    CGRect holeRection = CGRectMake([UIScreen mainScreen].bounds.size.width*50/320, [UIScreen mainScreen].bounds.size.height*180/576-40, [UIScreen mainScreen].bounds.size.width*220/320, [UIScreen mainScreen].bounds.size.width*220/320);
    /** union: 并集
     CGRect CGRectUnion(CGRect r1, CGRect r2)
     返回并集部分rect
     */
    
    /** Intersection: 交集
     CGRect CGRectIntersection(CGRect r1, CGRect r2)
     返回交集部分rect
     */
    CGRect holeiInterSection = CGRectIntersection(holeRection, rect);
    [[UIColor clearColor] setFill];
    
    //CGContextClearRect(ctx, <#CGRect rect#>)
    //绘制
    //CGContextDrawPath(ctx, kCGPathFillStroke);
    UIRectFill(holeiInterSection);
}

@end
