//
//  PlayRecordViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PlayRecordViewController.h"
#import "PlayRecordCell.h"
@interface PlayRecordViewController ()

@end

@implementation PlayRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放记录";
    [self setupMokeData];
    [self setupUI];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setupMokeData {
    self.dataArray = [@[@"你好",@"我好",@"大家好",@"很好",@"你好",@"我好",@"大家好",@"很好"] mutableCopy];
    [self stopLoading];
}
#pragma mark - setupUI
- (void)setupUI {
    [self.tableView registerClass:[PlayRecordCell class] forCellReuseIdentifier:@"PlayRecordCell"];
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
    PlayRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayRecordCell" forIndexPath:indexPath];
    if (self.dataArray.count <= 1) {
        cell.cellStatus = RadianBaseCellStatus_Top | RadianBaseCellStatus_Bottom;
    }else {
        if (indexPath.row == 0) {
            cell.cellStatus = RadianBaseCellStatus_Top;
        } else if (indexPath.row < self.dataArray.count - 1) {
            cell.cellStatus = RadianBaseCellStatus_Middle;
        } else {
            cell.cellStatus = RadianBaseCellStatus_Bottom;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}
@end
