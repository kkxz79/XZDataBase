//
//  XZFMDBManager.h
//  XZDataBase
//
//  Created by kkxz on 2018/12/18.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZFMDBManager : NSObject

+(instancetype)sharedInstance;
-(NSString*)getFliePath;///获取数据库路径
-(FMDatabase*)getDB;///获取数据库实例
-(void)dropTableWithTableName:(NSString*)tableName;///删除指定的表
-(BOOL)openDB;///打开数据库
-(void)closeDB;///关闭数据库
@end

NS_ASSUME_NONNULL_END
