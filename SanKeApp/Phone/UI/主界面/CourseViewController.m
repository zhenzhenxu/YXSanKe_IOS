//
//  CourseViewController.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTableViewCell.h"
#import "YXFileVideoItem.h"
#import "AloneCourseViewController.h"
#import "CourseVideoFetch.h"
@implementation CourseTabItem
@end;
@interface CourseViewController ()
@end

@implementation CourseViewController
- (void)dealloc{
    DDLogError(@"release====>%@,%@",NSStringFromClass([self class]),self.title);
}
- (void)viewDidLoad {
    CourseVideoFetch *fetcher = [[CourseVideoFetch alloc]init];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self setupUI];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.title = self.tabItem.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell" forIndexPath:indexPath];
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
    WEAK_SELF
    [cell setClickCourseTitleBlock:^{
        STRONG_SELF
        AloneCourseViewController *VC = [[AloneCourseViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    cell.element = self.dataArray[indexPath.row];
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
