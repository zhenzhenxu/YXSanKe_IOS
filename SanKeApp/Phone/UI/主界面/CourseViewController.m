//
//  CourseViewController.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTableViewCell.h"
@implementation CourseTabItem
@end;
@interface CourseViewController ()// <UITableViewDelegate, UITableViewDataSource>
@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMokeData];
    [self setupUI];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.title = self.tabItem.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setupMokeData {
    self.dataArray = [@[@"你好",@"我好",@"大家好",@"很好",@"你好",@"我好",@"大家好",@"很好"] mutableCopy];
}
#pragma mark - setupUI
- (void)setupUI {
    [self.tableView registerClass:[CourseTableViewCell class] forCellReuseIdentifier:@"CourseTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10.0f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.tableView.tableHeaderView = headerView;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10.0f)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.tableView.tableFooterView = footerView;
    [self stopLoading];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell" forIndexPath:indexPath];
    if (self.dataArray.count <= 1) {
        cell.cellStatus = CourseTableViewCellStatus_Top | CourseTableViewCellStatus_Bottom;
    }else {
        if (indexPath.row == 0) {
            cell.cellStatus = CourseTableViewCellStatus_Top;
        } else if (indexPath.row < self.dataArray.count - 1) {
            cell.cellStatus = CourseTableViewCellStatus_Middle;
        } else {
           cell.cellStatus = CourseTableViewCellStatus_Bottom;
        }
    }
    [cell setupMokeData:self.title];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}
@end
