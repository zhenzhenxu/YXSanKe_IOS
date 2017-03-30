//
//  QAMainViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAMainViewController.h"
#import "QAQuestionCell.h"
#import "QAQuestionListViewController.h"

@interface QAMainViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *hotButton;
@property (nonatomic, strong) UIButton *latestButton;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) QAQuestionListViewController *hotVC;
@property (nonatomic, strong) QAQuestionListViewController *latestVC;
@end

@implementation QAMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTitle];
    [self setupUI];
    [self setupRightWithTitle:@"提问"];
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

- (void)naviRightAction {
    
}

- (void)setupUI {
    UIView *filterContainerView = [[UIView alloc]init];
    filterContainerView.backgroundColor = [UIColor colorWithHexString:@"d65b4b"];
    [self.view addSubview:filterContainerView];
    [filterContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    self.hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hotButton setTitle:@"热门问题" forState:UIControlStateNormal];
    [self.hotButton setTitleColor:[UIColor colorWithHexString:@"fda89d"] forState:UIControlStateNormal];
    [self.hotButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    self.hotButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.hotButton addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.latestButton = [self.hotButton clone];
    [self.latestButton setTitle:@"最新问题" forState:UIControlStateNormal];
    [self.latestButton addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [filterContainerView addSubview:self.hotButton];
    [filterContainerView addSubview:self.latestButton];
    [self.hotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
    }];
    [self.latestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.hotButton.mas_right);
        make.width.mas_equalTo(self.hotButton.mas_width);
    }];
    self.hotButton.selected = YES;
    
    self.mainScrollView = [[UIScrollView alloc]init];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.directionalLockEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterContainerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    UIView *contentView = [[UIView alloc]init];
    [self.mainScrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(self.mainScrollView);
        make.width.mas_equalTo(self.mainScrollView).multipliedBy(2);
    }];
    
    self.hotVC = [[QAQuestionListViewController alloc]init];
    self.hotVC.sort_field = @"view_num";
    [self.mainScrollView addSubview:self.hotVC.view];
    self.latestVC = [[QAQuestionListViewController alloc]init];
    [self.mainScrollView addSubview:self.latestVC.view];
    [self addChildViewController:self.hotVC];
    [self addChildViewController:self.latestVC];
    
    [self.hotVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.view.width);
    }];
    [self.latestVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.view.width);
        make.width.mas_equalTo(self.view.width);
    }];
}

- (void)filterButtonAction:(UIButton *)sender {
    if (sender == self.hotButton) {
        if (sender.selected) {
            [self.hotVC firstPageFetch];
        }else {
            self.hotButton.selected = YES;
            self.latestButton.selected = NO;
            self.mainScrollView.contentOffset = CGPointMake(0, 0);
        }
    }else if (sender == self.latestButton) {
        if (sender.selected) {
            [self.latestVC firstPageFetch];
        }else {
            self.latestButton.selected = YES;
            self.hotButton.selected = NO;
            self.mainScrollView.contentOffset = CGPointMake(self.mainScrollView.width, 0);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.mainScrollView.contentOffset.x/self.mainScrollView.width;
    if (index == 0) {
        self.hotButton.selected = YES;
        self.latestButton.selected = NO;
    }else if (index == 1) {
        self.hotButton.selected = NO;
        self.latestButton.selected = YES;
    }
}

@end
