//
//  TabViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = self.label.name;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
