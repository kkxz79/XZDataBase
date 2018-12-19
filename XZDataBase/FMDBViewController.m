//
//  FMDBViewController.m
//  XZDataBase
//
//  Created by kkxz on 2018/12/18.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "FMDBViewController.h"
#import "XZFMDBManager.h"
#import "PersonModelDB.h"
#import "Person.h"
#import "BookInfoModelDB.h"

@interface FMDBViewController ()<UIActionSheetDelegate>

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"fmdb";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"action" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.navigationItem.rightBarButtonItem = barButton;
    
}

-(void)rightButtonAction {
    [[[UIActionSheet alloc]
      initWithTitle:@"FMDB数据库操作"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:nil
      otherButtonTitles:@"建Person表",@"添加人员信息1", @"添加人员信息2",@"添加人员信息3", @"添加人员信息4",@"条件删除",@"更新表数据",@"条件搜索",@"获取所有数据",@"删除表",@"关闭数据库",@"打开数据库",@"DatabaseQueue操作",nil]
     showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SEL selectors[] = {
        @selector(createTable),
        @selector(addPerson1),
        @selector(addPerson2),
        @selector(addPerson3),
        @selector(addPerson4),
        @selector(deletePersonWithName),
        @selector(updateWithPerson),
        @selector(setResultWithAge),
        @selector(setResultPerson),
        @selector(dropTable),
        @selector(closeSqlite),
        @selector(openSqlite),
        @selector(bookQueue)
    };
    
    if (buttonIndex < sizeof(selectors) / sizeof(SEL)) {
        void(*imp)(id, SEL) = (typeof(imp))[self methodForSelector:selectors[buttonIndex]];
        imp(self, selectors[buttonIndex]);
    }
}

#pragma mark - private methods
-(void)createTable {
    [PersonModelDB createPersonTable];
}

-(void)addPerson1 {
    Person * person = [[Person alloc] init];
    person.name = @"Tom";
    person.age = 19;
    person.score = 89.5;
    [PersonModelDB insertDataWithPerson:person];
}

-(void)addPerson2 {
    Person * person = [[Person alloc] init];
    person.name = @"Jack";
    person.age = 30;
    person.score = 90.5;
    [PersonModelDB insertDataWithPerson:person];
}

-(void)addPerson3 {
    Person * person = [[Person alloc] init];
    person.name = @"Rose";
    person.age = 26;
    person.score = 98.5;
    [PersonModelDB insertDataWithPerson:person];
}

-(void)addPerson4 {
    Person * person = [[Person alloc] init];
    person.name = @"Lily";
    person.age = 19;
    person.score = 93.5;
    [PersonModelDB insertDataWithPerson:person];
}

-(void)deletePersonWithName {
    [PersonModelDB deleteDataWithName:@"Tom"];
}

-(void)updateWithPerson {
    [PersonModelDB updateDataWithName:@"Jerry" whereScore:98.5];
}

-(void)setResultWithAge {
  NSMutableArray *arr =  [PersonModelDB resultSetWithAge:19];
    for(Person*person in arr){
        NSLog(@"name-%@ age- %ld score-%.2f",person.name,person.age,person.score);
    }
}

-(void)setResultPerson {
    NSMutableArray *arr = [PersonModelDB resultSetPerson];
    for(Person*person in arr){
        NSLog(@"name-%@ age- %ld score-%.2f",person.name,person.age,person.score);
    }
}

-(void)dropTable {
    [[XZFMDBManager sharedInstance] dropTableWithTableName:@"t_person"];
}

-(void)closeSqlite {
    [[XZFMDBManager sharedInstance] closeDB];
}

-(void)openSqlite {
    [[XZFMDBManager sharedInstance] openDB];
}

-(void)bookQueue {
    [BookInfoModelDB fmdbDatabaseQueueFunction];
}

@end
