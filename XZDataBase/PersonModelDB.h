//
//  PersonModelDB.h
//  XZDataBase
//
//  Created by kkxz on 2018/12/18.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Person;
@interface PersonModelDB : NSObject
+(void)createPersonTable;///打开人员信息表
+(void)insertDataWithPerson:(Person*)person;///添加数据
+(void)deleteDataWithName:(NSString*)name;//删除数据
+(void)updateDataWithName:(NSString*)name whereScore:(float)score;//修改数据
+(NSMutableArray*)resultSetWithAge:(NSInteger)age;//根据年龄查询表数据
+(NSMutableArray*)resultSetPerson;//查询所有表数据

@end

NS_ASSUME_NONNULL_END
