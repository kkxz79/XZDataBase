//
//  XZDBManager.m
//  XZDataBase
//
//  Created by kkxz on 2018/12/17.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "XZDBManager.h"
#import "Student.h"

@interface XZDBManager () {
    sqlite3 *_db;
}
@property(nonatomic,copy)NSString *filePath;

@end

@implementation XZDBManager

+(instancetype)sharedInstance {
    static XZDBManager * singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[XZDBManager alloc] init];
    });
    return singleton;
}

-(instancetype)init {
    self = [super init];
    if(self){
        //打开或创建数据库
        [self createSqlite];
    }
    return self;
}

-(void)createSqlite {
    //创建数据文件路径
    NSString * string = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [string stringByAppendingPathComponent:@"Student.sqlite"];
    NSLog(@"student sqlite path %@",path);
    self.filePath = path;
    
    //打开数据库
    int result = sqlite3_open(path.UTF8String, &_db);
    if(result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    }else {
        NSLog(@"数据库打开失败");
    }
}

//创建表
-(void)createTable {
    //创建表的SQLite语句，其中id是主键，not null表示创建记录时这些字段不能为NULL
    NSString *sqlite = [NSString stringWithFormat:@"create table if not exists t_student (id integer primary key autoincrement,name text not null,age integer)"];
    
    //用来记录错误信息
    char *error = NULL;
    //执行SQLite语句
    int result = sqlite3_exec(_db, sqlite.UTF8String, nil, nil, &error);
    if(result == SQLITE_OK){
        NSLog(@"创建表成功");
    }else {
        NSLog(@"创建表失败");
    }
}

//TODO:添加数据
-(void)addStudent:(Student*)stu {
    //添加数据的SQLite语句
    NSString *sqlite = [NSString stringWithFormat:@"insert into t_student (name,age) values ('%@','%ld')",stu.name,stu.age];
    char *error = NULL;
    int result = sqlite3_exec(_db, sqlite.UTF8String, nil, nil, &error);
    
    if(result == SQLITE_OK){
        NSLog(@"添加数据成功");
    }else {
        NSLog(@"添加数据失败");
    }
}

//TODO:删除数据
-(void)deleteStuWithName:(NSString *)name {
    //删除特定数据的SQLite语句
    NSString *sqlite = [NSString stringWithFormat:@"delete from t_student where name = '%@'",name];
    char *error = NULL;
    int result = sqlite3_exec(_db, sqlite.UTF8String, nil, nil, &error);
    
    if(result == SQLITE_OK){
        NSLog(@"删除数据成功");
    }else {
        NSLog(@"删除数据失败");
    }
}

//TODO:更新数据
-(void)updateWithStudent:(Student *)stu whereName:(NSString *)name {
    //更新特定字段的SQLite语句
    NSString *sqlite = [NSString stringWithFormat:@"update t_student set name = '%@',age = '%ld' where name = '%@'",stu.name,stu.age,name];
    char *error = NULL;
    int result = sqlite3_exec(_db, sqlite.UTF8String, nil, nil, &error);
    
    if(result == SQLITE_OK) {
        NSLog(@"更新数据成功");
    }else {
        NSLog(@"修改数据失败");
    }
}

//TODO:根据条件查询
-(NSMutableArray *)selectWithAge:(NSInteger)age {
    //可变数组，用来保存查询到的数据
    NSMutableArray *array = [NSMutableArray array];
    //查询所有的sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"select * from t_student where age = '%ld'",age];
    
    //定义一个stmt存放结果集
    sqlite3_stmt *stmt = NULL;
    //执行
    int result = sqlite3_prepare(_db, sqlite.UTF8String, -1, &stmt, NULL);
    
    if(result == SQLITE_OK){
        NSLog(@"查询成功");
        //遍历查询到所有数据，并添加到上面的数组中
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            Student *stu = [[Student alloc]init];
            //获取第1列的姓名，第0列是id
            stu.name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 1)];
            //获得第2列的年龄
            stu.age = sqlite3_column_int(stmt, 2);
            [array addObject:stu];
        }
    }else {
        NSLog(@"查询失败");
    }
    
    //销毁stmt,防止内存泄漏
    sqlite3_finalize(stmt);
    return array;
}

//TODO:查询所有数据
-(NSMutableArray*)selectStudent {
    NSMutableArray * array = [NSMutableArray array];
    //查询所有数据的sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"select * from t_student"];
    
    //定义一个stmt存放结果集
    sqlite3_stmt *stmt = NULL;
    //执行
    int result = sqlite3_prepare(_db, sqlite.UTF8String, -1, &stmt, NULL);
    
    if(result == SQLITE_OK){
        NSLog(@"查询成功");
        //遍历查询到所有数据，并添加到上面的数组中
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            Student *stu = [[Student alloc]init];
            //获取第1列的姓名，第0列是id
            stu.name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 1)];
            //获得第2列的年龄
            stu.age = sqlite3_column_int(stmt, 2);
            [array addObject:stu];
        }
    }else {
        NSLog(@"查询失败");
    }
    
    //销毁stmt,防止内存泄漏
    sqlite3_finalize(stmt);
    return array;
}

//TODO:删除表中的所有数据
-(void)deleteAllData {
    NSString *sqlite = [NSString stringWithFormat:@"delete from t_student"];
    char *error = NULL;
    int result = sqlite3_exec(_db, sqlite.UTF8String, nil, nil, &error);
    
    if(result == SQLITE_OK) {
        NSLog(@"清除数据库成功");
    }else {
        NSLog(@"清除数据库失败");
    }
}

//TODO:删除表
-(void)dropTable {
    NSString *sqlite = [NSString stringWithFormat:@"drop table if exists t_student"];
    char *error = NULL;
    int result = sqlite3_exec(_db, sqlite.UTF8String, nil, nil, &error);
    
    if(result == SQLITE_OK){
        NSLog(@"删除表成功");
    }else {
        NSLog(@"删除表失败");
    }
}

//TODO:关闭数据库
-(void)closeSqlite {
    int result = sqlite3_close(_db);
    if(result == SQLITE_OK) {
        NSLog(@"数据库关闭成功");
    }else {
        NSLog(@"数据库关闭失败");
    }
}

//TODO:打开数据库
-(void)openSqlite {
    int result = sqlite3_open(self.filePath.UTF8String, &_db);
    if(result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
    }else {
        NSLog(@"数据库打开失败");
    }
    
}

@synthesize filePath = _filePath;
@end
