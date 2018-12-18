//
//  XZDBManager.h
//  XZDataBase
//
//  Created by kkxz on 2018/12/17.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class Student;
NS_ASSUME_NONNULL_BEGIN

@interface XZDBManager : NSObject

+(instancetype)sharedInstance;
-(void)createSqlite;//创建数据库
-(void)createTable;//创建学生信息表
-(void)addStudent:(Student*)stu;//添加学生信息
-(void)deleteStuWithName:(NSString *)name;//根据姓名删除表数据
-(void)updateWithStudent:(Student *)stu whereName:(NSString *)name;//根据姓名更新表数据
-(NSMutableArray *)selectWithAge:(NSInteger)age;//根据年龄搜索表数据
-(NSMutableArray*)selectStudent;//搜索所有表数据
-(void)deleteAllData;//删除表数据
-(void)dropTable;//删除学生信息表
-(void)closeSqlite;//关闭数据库
-(void)openSqlite;//打开数据库
@end

NS_ASSUME_NONNULL_END
