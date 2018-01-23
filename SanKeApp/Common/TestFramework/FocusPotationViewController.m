//
//  FocusPotationViewController.m
//  SanKeApp
//
//  Created by 郑小龙 on 2018/1/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "FocusPotationViewController.h"
#import "FocusRotationView.h"
@interface FocusPotationViewController ()

@end

@implementation FocusPotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FocusRotationView *rotationView = [[FocusRotationView alloc] init];
    rotationView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rotationView];
    [rotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_offset(150.0f);
    }];
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor redColor];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor yellowColor];
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor blueColor];
    rotationView.itemViewArray = @[view1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
