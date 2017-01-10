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

@interface ProjectMainViewController ()

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction{
    PlayRecordViewController *vc = [[PlayRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
