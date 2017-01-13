//
//  AloneCourseViewController.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AloneCourseViewController.h"
#import "AloneCourseTableViewCell.h"
#import "YXFileVideoItem.h"
@interface AloneCourseViewController ()

@end

@implementation AloneCourseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMokeData];
    [self setupUI];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setupMokeData {
    self.dataArray = [@[@"你好",@"我好",@"大家好",@"很好",@"你好",@"我好",@"大家好",@"很好"] mutableCopy];
}
#pragma mark - setupUI
- (void)setupUI {
    
    [self.tableView registerClass:[AloneCourseTableViewCell class] forCellReuseIdentifier:@"AloneCourseTableViewCell"];
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
    AloneCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AloneCourseTableViewCell" forIndexPath:indexPath];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXFileVideoItem *videoItem = [[YXFileVideoItem alloc] init];
    videoItem.name = self.title;
    videoItem.url = @"http://yuncdn.teacherclub.com.cn/course/cf/2016bjxxjs/wh/xxylalkdx/video/2.1_l/2.1_l.m3u8";
    videoItem.baseViewController = self;
    [videoItem browseFile];
}
@end
