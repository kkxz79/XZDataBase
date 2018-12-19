//
//  PersonModelDB.m
//  XZDataBase
//
//  Created by kkxz on 2018/12/18.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "PersonModelDB.h"
#import "XZFMDBManager.h"
#import "Person.h"

@implementation PersonModelDB
+ (void)createPersonTable {
    //打开数据库并创建person表，person中有主键id，姓名name，年龄age，分数score
    //表存在就打开，表不存在就创建
    if([XZFMDBManager sharedInstance].openDB){
        //打开成功
        BOOL success = [[XZFMDBManager sharedInstance].getDB
                        executeUpdate:@"create table if not exists t_person (id integer primary key autoincrement,name text,age integer,score float)"];
        if(success){
            NSLog(@"打开person表成功");
        }else {
            NSLog(@"打开person表失败");
        }
    }
    else{
        NSLog(@"打开失败");
    }
}

+(void)insertDataWithPerson:(Person*)person {
    BOOL success = [[XZFMDBManager sharedInstance].getDB
                    executeUpdate:@"insert into t_person (name,age,score) values(?,?,?)",person.name,@(person.age),@(person.score)];
    if(success){
        NSLog(@"添加数据成功：%@-%ld-%.2f",person.name,person.age,person.score);
    }else{
        NSLog(@"添加数据失败");
    }
}

+(void)deleteDataWithName:(NSString*)name {
    BOOL success = [[XZFMDBManager sharedInstance].getDB
                    executeUpdate:@"delete from t_person where name = ?",name];
    if(success){
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
    }
}

+(void)updateDataWithName:(NSString*)name whereScore:(float)score {
    BOOL success = [[XZFMDBManager sharedInstance].getDB
                    executeUpdate:@"update t_person set name = ? where score = ?",name,@(score)];
    if(success){
        NSLog(@"更新数据成功");
    }else {
        NSLog(@"更新数据失败");
    }
}

+(NSMutableArray*)resultSetWithAge:(NSInteger)age {
    //可变数组，用来保存查询到的数据
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet * set = [[XZFMDBManager sharedInstance].getDB
                         executeQuery:@"select * from t_person where age = ?",@(age)];
    //数据遍历
    while ([set next]) {
        Person *person = [[Person alloc] init];
        person.name = [set stringForColumn:@"name"];
        person.age = [set longLongIntForColumn:@"age"];
        person.score = [set doubleForColumn:@"score"];
        [array addObject:person];
    }
    return array;
}

+(NSMutableArray*)resultSetPerson {
    //可变数组，用来保存查询到的数据
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet * set = [[XZFMDBManager sharedInstance].getDB
                         executeQuery:[NSString stringWithFormat:@"select * from t_person"]];
   //数据遍历
    while ([set next]) {
        Person *person = [[Person alloc] init];
        person.name = [set stringForColumn:@"name"];
        person.age = [set longLongIntForColumn:@"age"];
        person.score = [set doubleForColumn:@"score"];
        [array addObject:person];
    }
    return array;
}

@end
