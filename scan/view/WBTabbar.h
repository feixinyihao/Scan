//
//  WBTabbar.h
//  weibo
//
//  Created by 陈鑫荣 on 16/2/28.
//  Copyright © 2016年 unifound. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBTabbar;
@protocol WBTabBarDelegate <NSObject>

@optional
-(void)tabBardidClick:(WBTabbar*)tabBar from:(NSInteger)from to:(NSInteger)to;
@end
@interface WBTabbar : UIView
-(void)addButtonWithItem:(UITabBarItem*)item;
@property(nonatomic,strong)id <WBTabBarDelegate>delegate;
@end
