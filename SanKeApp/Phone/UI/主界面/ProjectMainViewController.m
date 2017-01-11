//
//  ProjectMainViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectMainViewController.h"
#import "YXDrawerController.h"
#import "PlayRecordViewController.h"
#import "ProjectContainerView.h"
#import "CourseViewController.h"
@interface ProjectMainViewController ()
@property (nonatomic, strong) NSMutableArray *dataMutableArrray;
@end

@implementation ProjectMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"主界面";
    UIButton *naviLeftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [naviLeftButton setTitle:@"我的" forState:UIControlStateNormal];
    [naviLeftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[naviLeftButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [YXDrawerController showDrawer];
    }];
    [self setupLeftWithCustomView:naviLeftButton];
    
    [self setupRightWithTitle:@"播放记录"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction{
    PlayRecordViewController *vc = [[PlayRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - setupUI
- (void)setupUI {
    [self setupMokeData];
    ProjectContainerView *containerView = [[ProjectContainerView alloc]initWithFrame:self.view.bounds];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    containerView.childViewControllers = self.childViewControllers;
    [self.view addSubview:containerView];
}

- (void)setupMokeData {
    self.dataMutableArrray = [@[@"全部",@"\"新\"在哪里",@"关键点位",@"颗粒研修"] mutableCopy];
    for (int i=0 ; i<self.dataMutableArrray.count ;i++){
        CourseTabItem *item = [[CourseTabItem alloc] init];
        item.name = self.dataMutableArrray[i];
        CourseViewController *vc = [[CourseViewController alloc] init];
        vc.tabItem = item;
        [self addChildViewController:vc];
    }
}



@end
