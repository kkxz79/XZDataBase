//
//  Person.h
//  XZDataBase
//
//  Created by kkxz on 2018/12/18.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,assign)float score;
@end

NS_ASSUME_NONNULL_END
