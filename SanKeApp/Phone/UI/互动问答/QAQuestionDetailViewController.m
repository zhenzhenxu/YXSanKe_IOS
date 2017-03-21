//
//  QAQuestionDetailViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionDetailViewController.h"
#import "QAReplyDetailViewController.h"
#import "QAQuestionDetailView.h"
#import "QAReplyCell.h"

@interface QAQuestionDetailViewController ()
@property (nonatomic, strong) QAQuestionDetailView *headerView;
@end

@implementation QAQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTitle];
    [self setupUI];
    if ([YXShareManager isQQSupport]||[YXShareManager isWXAppSupport]) {
        [self setupRightWithImageNamed:@"分享" highlightImageNamed:nil];
    }
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kStageSubjectDidChangeNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupTitle];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTitle {
    UserModel *model = [UserManager sharedInstance].userModel;
    [StageSubjectDataManager fetchStageSubjectWithStageID:model.stageID subjectID:model.subjectID completeBlock:^(FetchStageSubjectRequestItem_stage *stage, FetchStageSubjectRequestItem_subject *subject) {
        NSString *title = [stage.name stringByAppendingString:subject.name];
        self.navigationItem.title = title;
    }];
}

- (void)firstPageFetch {
    [self stopLoading];
}

- (void)naviRightAction {
    [[YXShareManager shareManager]yx_shareMessageWithImageIcon:nil title:@"分享标题" message:nil url:@"www.baidu.com" shareType:YXShareType_WeChat];
}

- (void)setupUI {
    self.headerView = [[QAQuestionDetailView alloc]init];
    self.headerView.type = 1;
    CGFloat height = [QAQuestionDetailView heightForWidth:self.view.width];
    self.headerView.frame = CGRectMake(0, 0, self.view.width, height);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 112;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QAReplyCell class] forCellReuseIdentifier:@"QAReplyCell"];
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAReplyCell"];
    return cell;
}

#pragma tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QAReplyDetailViewController *vc = [[QAReplyDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
