//
//  BookInfoModelDB.m
//  XZDataBase
//
//  Created by kkxz on 2018/12/18.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "BookInfoModelDB.h"
#import "XZFMDBManager.h"

@implementation BookInfoModelDB
+(void)fmdbDatabaseQueueFunction {
    //初始化FMDatabaseQueue
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:[XZFMDBManager sharedInstance].getFliePath];
    //在block中执行sqlite语句命令
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        //创建book表
        BOOL book =  [db executeUpdate:@"create table if not exists t_book (id integer primary key autoincrement,name text,author text,pages integer)"];
        if(book){
            NSLog(@"学生表打开成功");
            //插入数据
            BOOL add = [db executeUpdate:@"insert into t_book (name,author,pages) values (?,?,?)",@"魔戒前传",@"罗琳",@(987)];
            if(add){
                NSLog(@"魔戒前传-添加成功");
            }
            add = [db executeUpdate:@"insert into t_book (name,author,pages) values (?,?,?)",@"小王子",@"吉瑞",@(156)];
            if(add){
                NSLog(@"小王子-添加成功");
            }
            add = [db executeUpdate:@"insert into t_book (name,author,pages) values (?,?,?)",@"三国演义",@"罗贯中",@(958)];
            if(add){
                NSLog(@"三国演义-添加成功");
            }
            //删除数据
            BOOL delete = [db executeUpdate:@"delete from t_book where author = ?",@"罗贯中"];
            if(delete){
                NSLog(@"罗贯中-删除成功");
            }
            //更新数据
            BOOL update = [db executeUpdate:@"update t_book set name = ? where pages = ?",@"Tom",@(156)];
            if(update){
                NSLog(@"页数156，更新数据成功");
            }
            //查询数据
            FMResultSet *set = [db executeQuery:@"select * from t_book"];
            //遍历查询到的数据
            while ([set next]) {
                int Id = [set intForColumn:@"id"];
                NSString *name = [set stringForColumn:@"name"];
                NSString *author = [set stringForColumn:@"author"];
                NSInteger pages = [set longLongIntForColumn:@"pages"];
                NSLog(@"id:%d name:%@ author:%@ pages:%ld",Id,name,author,pages);
            }
        }
    }];
    
    //FMDatabaseQueue的事务inTransaction
    [dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
       //创建表
        [db executeUpdate:@"create table if not exists t_student (id integer primary key autoincrement,name text,age integer)"];
        //循环添加2000条数据
        for (int i = 0; i<100; i++) {
            BOOL success = [db executeUpdate:@"insert into t_student (name,age) values (?,?)",@"LiLi",@(i)];
            //如果添加数据出现问题，则回滚
            if(!success){
                NSLog(@"数据添加出现问题，执行回滚");
               *rollback = YES;
                return ;
            }
            else{
                NSLog(@"循环添加数据，整体成功");
            }
        }
    }];
}

@end
