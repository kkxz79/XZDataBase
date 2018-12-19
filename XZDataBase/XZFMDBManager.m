//
//  XZFMDBManager.m
//  XZDataBase
//
//  Created by kkxz on 2018/12/18.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "XZFMDBManager.h"

@interface XZFMDBManager()
@property(nonatomic,strong)FMDatabase *db;
@property(nonatomic,copy)NSString * filePath;
@end

@implementation XZFMDBManager
+(instancetype)sharedInstance {
    static XZFMDBManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[XZFMDBManager alloc] init];
    });
    return singleton;
}

-(instancetype)init {
    self = [super init];
    if(self){
        //创建数据库
        [self createFMDB];
    }
    return self;
}

/**
 创建数据库
 */
-(void)createFMDB {
    //存放数据路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * fPath = [path stringByAppendingPathComponent:@"fmdb.sqlite"];
    self.filePath = fPath;
    
    //初始化FMDatabase
    self.db = [FMDatabase databaseWithPath:fPath];
    BOOL isOpen = [self.db open];
    if(isOpen){
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
}

/**
 删除指定的表
 */
-(void)dropTableWithTableName:(NSString*)tableName {
    BOOL success = [self.db executeUpdate:[NSString stringWithFormat:@"drop table if exists '%@'",tableName]];
    if(success){
        NSLog(@"删除表-%@-成功",tableName);
    }else {
        NSLog(@"删除表失败");
    }
}

/**
 获取数据库路径
 */
-(NSString*)getFliePath {
    return self.filePath;
}

/**
 获取数据库实例
 */
-(FMDatabase*)getDB {
    return self.db;
}

/**
 关闭数据库
 */
-(void)closeDB {
    BOOL isClose =  [self.db close];
    if(isClose){
        NSLog(@"数据库关闭成功");
    }else{
        NSLog(@"数据库关闭失败");
    }
}

/**
 打开数据库
 */
-(BOOL)openDB {
    BOOL isOpen =  [self.db open];
    if(isOpen){
        NSLog(@"打开数据库成功");
    }else {
        NSLog(@"打开数据库失败");
    }
    return isOpen;
}

@synthesize db = _db;
@synthesize filePath = _filePath;
@end
