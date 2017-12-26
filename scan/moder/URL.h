//
//  URL.h
//  scan
//
//  Created by 陈鑫荣 on 2017/12/23.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URL : NSObject

/**
 记录id
 */
@property(nonatomic,strong)NSNumber*ID;

/**
 扫描url
 */
@property(nonatomic,copy)NSString*url;

/**
 扫描时间
 */
@property(nonatomic,copy)NSString*usedTime;
@end
