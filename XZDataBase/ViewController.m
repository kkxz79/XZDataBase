//
//  ViewController.m
//  XZDataBase
//
//  Created by kkxz on 2018/12/17.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "ViewController.h"
#import "XZDBManager.h"
#import "Student.h"
#import "FMDBViewController.h"

@interface ViewController ()<UIActionSheetDelegate>
@property(nonatomic,strong)UIButton *sqliteBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DB";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"action" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.sqliteBtn.frame = CGRectMake(40.0f, 80.0f, self.view.frame.size.width-80.0f, 40.0f);
    [self.view addSubview:self.sqliteBtn];
    
}

-(void)sqliteBtnClick {
    [[[UIActionSheet alloc]
      initWithTitle:@"数据库操作"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:nil
      otherButtonTitles:@"创建数据库",@"建学生表",@"添加学生信息1", @"添加学生信息2",@"添加学生信息3", @"添加学生信息4",@"条件删除",@"更新表数据",@"条件搜索",@"获取所有数据",@"删除数据",@"删除表",@"关闭数据库",@"打开数据库",nil]
     showInView:self.view];
}

-(void)rightButtonAction {
    FMDBViewController * fmdbVC = [[FMDBViewController alloc] init];
    [self.navigationController pushViewController:fmdbVC animated:YES];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SEL selectors[] = {
        @selector(createSqlite),
        @selector(createTable),
        @selector(addStudent1),
        @selector(addStudent2),
        @selector(addStudent3),
        @selector(addStudent4),
        @selector(deleteStuWithName),
        @selector(updateWithStudent),
        @selector(selectWithAge),
        @selector(selectStudent),
        @selector(deleteAllData),
        @selector(dropTable),
        @selector(closeSqlite),
        @selector(openSqlite)
    };
    
    if (buttonIndex < sizeof(selectors) / sizeof(SEL)) {
        void(*imp)(id, SEL) = (typeof(imp))[self methodForSelector:selectors[buttonIndex]];
        imp(self, selectors[buttonIndex]);
    }
}

-(void)createSqlite {
    [XZDBManager sharedInstance];
}

-(void)createTable {
    [[XZDBManager sharedInstance] createTable];
}

-(void)addStudent1 {
    Student * stu = [[Student alloc] init];
    stu.name = @"小白";
    stu.age = 22;
    [[XZDBManager sharedInstance] addStudent:stu];
}

-(void)addStudent2 {
    Student * stu = [[Student alloc] init];
    stu.name = @"小黑";
    stu.age = 19;
    [[XZDBManager sharedInstance] addStudent:stu];
}

-(void)addStudent3 {
    Student * stu = [[Student alloc] init];
    stu.name = @"小黄";
    stu.age = 23;
    [[XZDBManager sharedInstance] addStudent:stu];
}

-(void)addStudent4 {
    Student * stu = [[Student alloc] init];
    stu.name = @"小红";
    stu.age = 30;
    [[XZDBManager sharedInstance] addStudent:stu];
}

-(void)deleteStuWithName {
    [[XZDBManager sharedInstance] deleteStuWithName:@"小红"];
}

-(void)updateWithStudent {
    Student * stu = [[Student alloc] init];
    stu.name = @"大白";
    stu.age = 27;
    [[XZDBManager sharedInstance] updateWithStudent:stu whereName:@"小黑"];
}

-(void)selectWithAge {
  NSMutableArray *array =  [[XZDBManager sharedInstance] selectWithAge:22];
  for(Student * stu in array){
      NSLog(@"姓名：%@ 年龄：%ld",stu.name,stu.age);
  }
}

-(void)selectStudent {
    NSMutableArray *array = [[XZDBManager sharedInstance]selectStudent];
    for(Student * stu in array){
        NSLog(@"姓名：%@ 年龄：%ld",stu.name,stu.age);
    }
}

-(void)deleteAllData {
    [[XZDBManager sharedInstance]deleteAllData];
    NSMutableArray *array = [[XZDBManager sharedInstance]selectStudent];
    NSLog(@"%@",array);
}

-(void)dropTable {
    [[XZDBManager sharedInstance]dropTable];
}

-(void)closeSqlite {
    [[XZDBManager sharedInstance] closeSqlite];
}

-(void)openSqlite {
    [[XZDBManager sharedInstance]openSqlite];
}

#pragma mark - lazy init
@synthesize sqliteBtn = _sqliteBtn;
-(UIButton *)sqliteBtn {
    if(!_sqliteBtn){
        _sqliteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sqliteBtn setTitle:@"sqlite3" forState:UIControlStateNormal];
        [_sqliteBtn addTarget:self action:@selector(sqliteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sqliteBtn;
}
@end
