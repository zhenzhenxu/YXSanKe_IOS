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
@implementation CourseVideoItem
@end;
@interface CourseViewController ()
@end

@implementation CourseViewController
- (void)dealloc{
    DDLogError(@"release====>%@,%@",NSStringFromClass([self class]),self.title);
}
- (void)viewDidLoad {
    CourseVideoFetch *fetcher = [[CourseVideoFetch alloc]init];
    fetcher.filterID = self.videoItem.filterID;
    fetcher.catID = self.videoItem.catID;
    fetcher.fromType = self.videoItem.fromType;
    fetcher.lastID = 0;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self setupUI];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    self.title = self.videoItem.name;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.projectNavRightView.leftButton.hidden = [self.videoItem.catID isEqualToString:@"0"];
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
    self.selectionView = [FilterSelectionView new];
    WEAK_SELF
    [self.selectionView setCompleteBlock:^(NSString *filterId) {
        STRONG_SELF
        CourseVideoFetch *fetcher = (CourseVideoFetch *)self.dataFetcher;
        fetcher.filterID = filterId;
        fetcher.fromType = 1;
        [self startLoading];
        [self firstPageFetch];
    }];
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
    WEAK_SELF
    [cell setClickCourseTitleBlock:^{
        STRONG_SELF
        AloneCourseViewController *VC = [[AloneCourseViewController alloc] init];
        VC.catID = element.catid;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseVideoRequestItem_Data_Elements *element = self.dataArray[indexPath.row];
    YXFileVideoItem *videoItem = [[YXFileVideoItem alloc] init];
    videoItem.name = element.title;
    videoItem.url = element.videos;
    videoItem.baseViewController = self;
    videoItem.record = [NSString stringWithFormat:@"%f", element.timeWatched.floatValue / element.totalTime.floatValue];
    videoItem.resourceID = element.videoID;
    [videoItem browseFile];
}
@end
