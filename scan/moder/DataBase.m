//
//  Database.m
//  scan
//
//  Created by 陈鑫荣 on 2017/12/23.
//  Copyright © 2017年 justprint. All rights reserved.
//

#import "DataBase.h"
#import <FMDatabase.h>
#import "URL.h"
#import<objc/runtime.h>

static DataBase *_DBCtl = nil;

@interface DataBase(){
    FMDatabase  *_db;

}

@end

@implementation DataBase

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}
+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}
- (NSArray *)allProperties:(id)class {
    unsigned int count;
    
    // 获取类的所有属性
    // 如果没有属性，则count为0，properties为nil
    objc_property_t *properties = class_copyPropertyList([class class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        // 获取属性名称
        //const char *propertyName = property_getName(properties[i]);
       // NSString *name = [NSString stringWithUTF8String:propertyName];
        NSString*property=[NSString stringWithUTF8String:property_getAttributes(properties[i])];
        [propertiesArray addObject:property];
    }
    
    // 注意，这里properties是一个数组指针，是C的语法，
    // 我们需要使用free函数来释放内存，否则会造成内存泄露
    free(properties);
    
    return propertiesArray;
}


-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
    NSString *urlSql = @"CREATE TABLE  IF NOT EXISTS 'tblUrl'  ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'url_id' VARCHAR(255),'url' VARCHAR(255),'usedTime' VARCHAR(255)) ";

    
    [_db executeUpdate:urlSql];
    
    
    [_db close];
    
}
#pragma mark - 接口
/**
 *  添加URl
 *
 */
- (void)addUrl:(URL *)url{
    [_db open];
    
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM tblUrl "];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"url_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"url_id"] integerValue] ) ;
        }
        
    }
    maxID = @([maxID integerValue] + 1);
    
    [_db executeUpdate:@"INSERT INTO tblUrl(url_id,url,usedTime)VALUES(?,?,?)",maxID,url.url,url.usedTime];

    [_db close];
    
}
/**
 *  删除URL
 *
 */
- (void)deleteUrl:(URL *)url{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM tblUrl WHERE url_id = ?",url.ID];
    
    [_db close];
    
}
/**
 *  更新URL
 *
 */
- (void)updateUrl:(URL *)url{
    [_db open];
    [_db executeUpdate:@"UPDATE 'tblUrl' SET url = ?  WHERE url_id = ? ",url.url,url.ID];
    [_db executeUpdate:@"UPDATE 'tblUrl' SET usedTime = ?  WHERE url_id = ? ",url.usedTime,url.ID];

    [_db close];
    
}

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllUrl{
    
    [_db open];
        
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM tblUrl ORDER BY id DESC"];
        
    while ([res next]) {
        URL*url=[[URL alloc]init];
        url.ID= @([[res stringForColumn:@"url_id"] integerValue]);
        url.url = [res stringForColumn:@"url"];
        url.usedTime=[res stringForColumn:@"usedTime"];
        [dataArray addObject:url];
    }
        
    [_db close];
    
    return dataArray;
    
}

/**
 模糊搜索

 @param key 搜索关键字
 @return 返回对象数组
 */
-(NSMutableArray*)getUrlLike:(NSString*)key{
    [_db open];
    NSMutableArray*dataArray=[NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tblUrl WHERE url like '%%%@%%' ORDER BY id DESC",key];
    FMResultSet*res=[_db executeQuery:sql];
    while ([res next]) {
        URL*url=[[URL alloc]init];
        url.ID= @([[res stringForColumn:@"url_id"] integerValue]);
        url.url = [res stringForColumn:@"url"];
        url.usedTime=[res stringForColumn:@"usedTime"];
        [dataArray addObject:url];
    }
    [_db close];
    return dataArray;
    
/**
 删除所有url
 */
}
-(void)deleteAllUrl{
    [_db open];
    NSString*sql=[NSString stringWithFormat:@"DELETE FROM tblUrl"];
    [_db executeUpdate:sql];
    [_db close];
}
@end
