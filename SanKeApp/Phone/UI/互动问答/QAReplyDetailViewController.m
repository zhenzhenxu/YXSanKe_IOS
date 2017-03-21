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

@interface QAReplyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation QAReplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"你瞅啥";
    [self setupUI];
    if ([YXShareManager isQQSupport]||[YXShareManager isWXAppSupport]) {
        [self setupRightWithImageNamed:@"分享" highlightImageNamed:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction {
    [[YXShareManager shareManager]yx_shareMessageWithImageIcon:nil title:@"分享标题" message:nil url:@"www.baidu.com" shareType:YXShareType_WeChat];
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
        DDLogVerbose(@"我来回答 clicked!");
    }];
    QAReplyDetailMenuItemView *favorMenu = [self menuViewWithTitle:@"喜欢" image:@"喜欢" actionBlock:^{
        STRONG_SELF
        DDLogVerbose(@"喜欢 clicked!");
    }];
    QAReplyDetailMenuItemView *questionMenu = [self menuViewWithTitle:@"我要提问" image:@"我要提问" actionBlock:^{
        STRONG_SELF
        DDLogVerbose(@"我要提问 clicked!");
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

#pragma makr - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAReplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAReplyDetailCell"];
    return cell;
}

@end
