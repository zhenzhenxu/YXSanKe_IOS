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
#import "FilterSelectionView.h"
#import "YXRecordManager.h"
#import "PlayRecordViewController.h"

@implementation CourseVideoItem
@end
@interface CourseViewController ()
@property (nonatomic, strong) ChannelTabFilterRequest *selectionRequest;
@property (nonatomic, strong) YXFileVideoItem *fileVideoItem;

@end

@implementation CourseViewController
- (void)dealloc{
    DDLogError(@"release====>%@,%@",NSStringFromClass([self class]),self.title);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    CourseVideoFetch *fetcher = [[CourseVideoFetch alloc]init];
    fetcher.filterID = self.videoItem.filterID;
    fetcher.catID = self.videoItem.catID;
    fetcher.fromType = self.videoItem.fromType;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self setupUI];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.title = self.videoItem.name;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kRecordReportSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kRecordDeletNotification object:nil];
}

- (void)refresh:(NSNotification *)notification{
    NSString *resourceID = notification.userInfo[kResourceIDKey];
    for (CourseVideoRequestItem_Data_Elements *item in self.dataArray) {
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
    CourseVideoRequestItem_Data_Elements *element = self.dataArray[indexPath.row];
    cell.element = element;
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
    videoItem.record = element.watchRecord;
    videoItem.duration = element.totalTime;
    videoItem.resourceID = element.resourceId;
    [videoItem browseFile];
    self.fileVideoItem = videoItem;
    
    
    YXProblemItem *item = [[YXProblemItem alloc]init];
    item.grade = [UserManager sharedInstance].userModel.stageID;
    item.subject = [UserManager sharedInstance].userModel.subjectID;
    item.section_id = self.videoItem.catID ;
    item.edition_id = self.recordItem.edition_id ?self.recordItem.edition_id : [NSString string];
    item.volume_id = self.recordItem.volume_id ? self.recordItem.volume_id :[NSString string];
    item.unit_id = self.recordItem.unit_id ? self.recordItem.unit_id : [NSString string];
    item.course_id = self.recordItem.course_id ? self.recordItem.course_id : [NSString string];
    item.object_id = videoItem.resourceID;
    item.object_name = videoItem.name;
    item.type = YXRecordClickType;
    item.objType = @"video";
    [YXRecordManager addRecord:item];
}

- (void)showFilterSelectionView {
    if (self.selectionView) {
        [self showSelectionView];
    }else {
        [self requestSelection];
    }
}
- (void)showSelectionView {
    FilterSelectionView *selectionView = self.selectionView;
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = selectionView;
    WEAK_SELF
    [alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view.mas_right);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*300/375);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_right);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*300/375);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(view.mas_right);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*300/375);
            }];
            [view layoutIfNeeded];
        }];
    }];
    [selectionView setCompleteBlock:^(YXProblemItem *item) {
        STRONG_SELF
        [alert hide];
        CourseVideoFetch *fetcher = (CourseVideoFetch *)self.dataFetcher;
        self.recordItem = item;
        
        NSString *f1 = item.edition_id? item.edition_id:@"0";
        NSArray *arr = [item.volume_id componentsSeparatedByString:@","];
        NSString *f2 = arr.lastObject? arr.lastObject:@"0";
        NSString *f3 = item.unit_id? item.unit_id:@"0";
        NSString *f4 = item.course_id? item.course_id:@"0";
        
        NSArray *array = @[f1,f2,f3,f4];
        NSString *filterString = [array componentsJoinedByString:@","];
        fetcher.filterID = filterString;
        fetcher.fromType = 1;
        [self startLoading];
        [self firstPageFetch];
    }];
}
- (void)requestSelection{
    [self.selectionRequest stopRequest];
    self.selectionRequest = [ChannelTabFilterRequest new];
    self.selectionRequest.catid = self.videoItem.catID;
    [self startLoading];
    self.projectNavRightView.leftButton.enabled = NO;
    WEAK_SELF
    [self.selectionRequest startRequestWithRetClass:[ChannelTabFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        self.projectNavRightView.leftButton.enabled = YES;
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        ChannelTabFilterRequestItem *item = retItem;
        self.selectionView = [[FilterSelectionView alloc]init];
        self.selectionView.data = item.data;
        self.selectionView.sectionId = self.videoItem.catID;
        [self showSelectionView];
    }];
}

@end
