//
//  WBTabbar.m
//  weibo
//
//  Created by 陈鑫荣 on 16/2/28.
//  Copyright © 2016年 unifound. All rights reserved.
//

#import "WBTabbar.h"
#import "CustomButton.h"
@interface WBTabbar()
@property(nonatomic,weak)CustomButton* selectedButton;
@end
@implementation WBTabbar


-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        //return self;
    

    }
    return self;
}
-(void)addButtonWithItem:(UITabBarItem*)item{
    CustomButton* btn=[[CustomButton alloc]init];
    [self addSubview:btn];
    btn.item=item;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    if (self.subviews.count==1) {
        [self buttonClick:btn];
    }
    

}
-(void)buttonClick:(CustomButton*)button{
    if ([self.delegate respondsToSelector:@selector(tabBardidClick:from:to:)]) {
        [self.delegate tabBardidClick:self from:self.selectedButton.tag to:button.tag];
        //NSLog(@"===");
    }

    self.selectedButton.selected=NO;
    button.selected=YES;
    self.selectedButton=button;
    //[button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW=self.frame.size.width/self.subviews.count;
    CGFloat btnY=0;
    CGFloat btnH=self.frame.size.height;
    for (int index=0; index<self.subviews.count; index++) {
        UIButton*btn=self.subviews[index];
        CGFloat btnX=index*btnW;
        btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
        btn.tag=index;
    }


    
}


@end
