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
#import "HistoryDeleteRequest.h"

NSString * const kRecordDeletNotification = @"kRecordDeletNotification";

@interface PlayRecordViewController ()
@property (nonatomic, strong) PlayHistoryFetch *historyFetch;
@property (nonatomic, assign) BOOL freshed;
@property (nonatomic, strong) YXFileVideoItem *videoItem;
@property (nonatomic, strong) HistoryDeleteRequest *historyDeleteRequest;
@end

@implementation PlayRecordViewController
- (void)dealloc{
    DDLogError(@"release====>%@,%@",NSStringFromClass([self class]),self.title);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    PlayHistoryFetch *fetch = [[PlayHistoryFetch alloc] init];
    self.dataFetcher = fetch;
    [super viewDidLoad];
    WEAK_SELF
    fetch.ListCompleteBlock = ^(){
        STRONG_SELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToast:@"暂无播放记录"];
        });
    };

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
    if ([history.state isEqualToString:@"2"]) {
        [self showToast:@"该视频不存在"];
        return;
    }
    YXFileVideoItem *videoItem = [[YXFileVideoItem alloc] init];
    videoItem.name = history.title;
    videoItem.url = history.videosMp4;
    videoItem.resourceID = history.resourceId;
    videoItem.record = history.watchRecord;
    videoItem.duration = history.totalTime;
    videoItem.baseViewController = self;
    self.videoItem = videoItem;
    [videoItem browseFile];
    
    YXProblemItem *item = [[YXProblemItem alloc]init];
    item.grade = [UserManager sharedInstance].userModel.stageID;
    item.subject = [UserManager sharedInstance].userModel.subjectID;
    item.section_id = [NSString string];
    item.edition_id = [NSString string];
    item.volume_id = [NSString string];
    item.unit_id = [NSString string];
    item.course_id = [NSString string];
    item.object_id = videoItem.resourceID;
    item.object_name = videoItem.name;
    item.type = YXRecordClickType;
    item.objType = @"video";
    [YXRecordManager addRecord:item];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLogDebug(@"编辑删除");
    if (self.historyDeleteRequest) {
        [self.historyDeleteRequest stopRequest];
    }
    self.historyDeleteRequest = [[HistoryDeleteRequest alloc] init];
    PlayHistoryRequestItem_Data_History *history = self.dataArray[indexPath.row];
    self.historyDeleteRequest.resourceId = history.resourceId;
    WEAK_SELF
    [self startLoading];
    [self.historyDeleteRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        NSString *resourceID = self.historyDeleteRequest.resourceId;
          [[NSNotificationCenter defaultCenter] postNotificationName:kRecordDeletNotification object:nil userInfo:@{kResourceIDKey:resourceID}];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        if ([self.dataArray count] == 0) {
            [self showToast:@"暂无播放记录"];
            [self.contentView addSubview:self.emptyView];
            [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        } else {
            [self.emptyView removeFromSuperview];
        }
    }];
}

@end
