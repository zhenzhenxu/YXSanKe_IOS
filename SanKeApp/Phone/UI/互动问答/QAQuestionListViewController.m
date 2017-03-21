//
//  QAQuestionListViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionListViewController.h"
#import "QAQuestionCell.h"
#import "QAQuestionDetailViewController.h"

@interface QAQuestionListViewController ()

@end

@implementation QAQuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstPageFetch {
    [self stopLoading];
}

- (void)setupUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 112;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QAQuestionCell class] forCellReuseIdentifier:@"QAQuestionCell"];
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionCell"];
    return cell;
}

#pragma tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QAQuestionDetailViewController *vc = [[QAQuestionDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
