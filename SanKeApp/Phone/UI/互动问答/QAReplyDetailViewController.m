//
//  QAReplyDetailViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyDetailViewController.h"
#import "QAReplyDetailCell.h"
#import "QAReplyDetailMenuItemView.h"
#import "QAReplyQuestionViewController.h"

@interface QAReplyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QAReplyDetailCell *detailCell;
@end

@implementation QAReplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.questionTitle;
    if ([YXShareManager isQQSupport]||[YXShareManager isWXAppSupport]) {
        [self setupRightWithImageNamed:@"分享" highlightImageNamed:nil];
    }
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction {
    [[YXShareManager shareManager]yx_shareMessageWithImageIcon:nil title:@"分享标题" message:nil url:@"www.baidu.com" shareType:YXShareType_WeChat];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kQAReplyInfoUpdateNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        if ([dic[kQAReplyIDKey] isEqualToString:self.item.elementID]) {
            self.item.likeInfo.likeNum = dic[kQAReplyFavorCountKey];
            self.detailCell.item = self.item;
        }
    }];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[QAReplyDetailCell class] forCellReuseIdentifier:@"QAReplyDetailCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
    }];
    
    UIView *menuContainerView = [[UIView alloc]init];
    menuContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuContainerView];
    [menuContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom);
    }];
    
    WEAK_SELF
    QAReplyDetailMenuItemView *replyMenu = [self menuViewWithTitle:@"我来回答" image:@"我来回答" actionBlock:^{
        STRONG_SELF
        [self handleReply];
        DDLogVerbose(@"我来回答 clicked!");
    }];
    QAReplyDetailMenuItemView *favorMenu = [self menuViewWithTitle:@"喜欢" image:@"喜欢" actionBlock:^{
        STRONG_SELF
        [self handleFavor];
    }];
    QAReplyDetailMenuItemView *questionMenu = [self menuViewWithTitle:@"我要提问" image:@"我要提问" actionBlock:^{
        STRONG_SELF
        [self handleQuestion];
    }];
    
    [menuContainerView addSubview:replyMenu];
    [menuContainerView addSubview:favorMenu];
    [menuContainerView addSubview:questionMenu];
    [replyMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    [favorMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(replyMenu.mas_right);
        make.width.mas_equalTo(replyMenu.mas_width);
    }];
    [questionMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(favorMenu.mas_right);
        make.width.mas_equalTo(favorMenu.mas_width);
    }];
}

- (QAReplyDetailMenuItemView *)menuViewWithTitle:(NSString *)title image:(NSString *)imageName actionBlock:(void(^)())actionBlock {
    QAReplyDetailMenuItemView *menuView = [[QAReplyDetailMenuItemView alloc]init];
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-点击",imageName]];
    [menuView updateWithImage:image highlightImage:highlightImage title:title];
    [menuView setActionBlock:actionBlock];
    return menuView;
}

- (void)handleReply {
    QAReplyQuestionViewController *vc = [[QAReplyQuestionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleFavor {
    [self startLoading];
    WEAK_SELF
    [QADataManager requestReplyFavorWithID:self.item.elementID completeBlock:^(QAReplyFavorRequestItem *item, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
    }];
}

- (void)handleQuestion {

}

#pragma makr - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAReplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAReplyDetailCell"];
    cell.item = self.item;
    self.detailCell = cell;
    return cell;
}

@end
