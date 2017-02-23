//
//  PlayRecordViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PlayRecordViewController.h"
#import "PlayRecordCell.h"
#import "PlayHistoryFetch.h"
#import "YXFileVideoItem.h"
@interface PlayRecordViewController ()
@property (nonatomic, strong) PlayHistoryFetch *historyFetch;
@property (nonatomic, assign) BOOL freshed;
@property (nonatomic, strong) YXFileVideoItem *videoItem;
@end

@implementation PlayRecordViewController

- (void)viewDidLoad {
    PlayHistoryFetch *fetch = [[PlayHistoryFetch alloc] init];
    self.dataFetcher = fetch;
    [super viewDidLoad];
    self.title = @"播放记录";
    [self setupUI];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.freshed = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kRecordReportSuccessNotification object:nil];
}

- (void)refresh:(NSNotification *)notification{
    NSString *resourceID = notification.userInfo[kResourceIDKey];
    for (PlayHistoryRequestItem_Data_History *item in self.dataArray) {
        if ([item.resourceId isEqualToString:resourceID]) {
            [self startLoading];
            [self firstPageFetch];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setupMokeData {
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
    cell.history = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayHistoryRequestItem_Data_History *history = self.dataArray[indexPath.row];
    YXFileVideoItem *videoItem = [[YXFileVideoItem alloc] init];
    videoItem.name = history.title;
    videoItem.url = history.videosMp4;
    videoItem.resourceID = history.resourceId;
    videoItem.record = history.watchRecord;
    videoItem.duration = history.totalTime;
    videoItem.baseViewController = self;
    self.videoItem = videoItem;
    [videoItem browseFile];
}
@end
