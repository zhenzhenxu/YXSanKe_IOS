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
#import "CourseVideoFetch.h"
#import "YXProblemItem.h"
#import "YXRecordManager.h"
@interface AloneCourseViewController ()

@property (nonatomic, strong) YXFileVideoItem *videoItem;
@end

@implementation AloneCourseViewController
- (void)viewDidLoad {
    CourseVideoFetch *fetcher = [[CourseVideoFetch alloc]init];
    fetcher.filterID = self.filterID;
    fetcher.catID = self.catID;
    fetcher.fromType = 2;
    fetcher.lastID = 0;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self setupUI];
    self.title = @"课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    YXProblemItem *item = [YXProblemItem new];
    item.objType = @"course";
    item.objId = self.catID;
    item.type = YXRecordClickType;
    item.objName = self.title;
    [YXRecordManager addRecord:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    cell.element = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseVideoRequestItem_Data_Elements *element = self.dataArray[indexPath.row];
    YXFileVideoItem *videoItem = [[YXFileVideoItem alloc] init];
    videoItem.name = element.title;
    videoItem.url = element.videosMp4;
    videoItem.baseViewController = self;
    videoItem.record = element.timeWatched;
    videoItem.duration = element.totalTime;
    videoItem.resourceID = element.resourceId;
    self.videoItem = videoItem;
    [videoItem browseFile];
}
@end
