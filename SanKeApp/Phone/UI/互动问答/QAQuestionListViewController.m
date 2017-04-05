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
#import "QAQuestionListFetcher.h"

@interface QAQuestionListViewController ()

@end

@implementation QAQuestionListViewController

- (void)viewDidLoad {
    QAQuestionListFetcher *fetcher = [[QAQuestionListFetcher alloc]init];
    fetcher.sort_field = self.sort_field;
    fetcher.pageSize = 20;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 112;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QAQuestionCell class] forCellReuseIdentifier:@"QAQuestionCell"];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kQAQuestionInfoUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSString *questionID = dic[kQAQuestionIDKey];
        NSString *replyCount = dic[kQAQuestionReplyCountKey];
        NSString *browseCount = dic[kQAQuestionBrowseCountKey];
        NSMutableArray *indexPathArray = [NSMutableArray array];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QAQuestionListRequestItem_Element *item = (QAQuestionListRequestItem_Element *)obj;
            if ([item.elementID isEqualToString:questionID]) {
                if (!isEmpty(replyCount)) {
                    if (replyCount.integerValue >= 10000) {
                        item.answerNum = @"9999+";
                    }else {
                        item.answerNum = replyCount;
                    }
                }
                if (!isEmpty(browseCount)) {
                    if (browseCount.integerValue >= 10000) {
                        item.viewNum = @"9999+";
                    }else {
                        item.viewNum = browseCount;
                    }
                }
                [indexPathArray addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }
        }];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - tableview datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionCell"];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

#pragma tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QAQuestionListRequestItem_Element *item = self.dataArray[indexPath.row];
    QAQuestionDetailViewController *vc = [[QAQuestionDetailViewController alloc]init];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
    
    //问题详情数据在问题列表接口的返回中都有了，所以不需要关心问题详情接口的返回，详情接口仅用于上报浏览数和更新字段值
    [QADataManager requestQuestionDetailWithID:item.elementID completeBlock:nil];
}
@end
