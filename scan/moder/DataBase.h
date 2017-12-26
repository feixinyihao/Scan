//
//  Database.h
//  scan
//
//  Created by 陈鑫荣 on 2017/12/23.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import <Foundation/Foundation.h>
@class URL;
@interface DataBase : NSObject
@property(nonatomic,strong)URL*url;

+ (instancetype)sharedDataBase;
#pragma mark URL
/**
 *  添加URl
 *
 */
- (void)addUrl:(URL *)url;
/**
 *  删除person
 *
 */
- (void)deleteUrl:(URL *)url;
/**
 *  更新person
 *
 */
- (void)updateUrl:(URL *)url;

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllUrl;

/**
 模糊搜索
 
 @param key 搜索关键字
 @return 返回对象数组
 */
-(NSMutableArray*)getUrlLike:(NSString*)key;

/**
 删除所有url
 */
-(void)deleteAllUrl;
@end
