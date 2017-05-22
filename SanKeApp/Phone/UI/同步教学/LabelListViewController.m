//
//  LabelListViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LabelListViewController.h"
#import "LabelViewController.h"
#import "LabelListContainerView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width



@interface LabelListViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) LabelListContainerView *containerView;


@end

@implementation LabelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    [self setupUI];
    [self setupTabContent];
    
    // Do any additional setup after loading the view.
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

- (void)setupUI {
    self.containerView = [[LabelListContainerView alloc]initWithFrame:self.view.bounds];
    self.containerView.hidden = YES;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.containerView];
}

- (void)setupTabContent {
    self.containerView.hidden = NO;
    for (LabelViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (GetBookInfoRequestItem_Label *label in self.tabArray) {
        LabelViewController *vc = [[LabelViewController alloc] init];
        vc.label = label;
        [self addChildViewController:vc];
    }
    WEAK_SELF
    [self.containerView setClickTabButtonBlock:^{
        STRONG_SELF
        //请求标签资源列表
        
    }];
    self.containerView.childViewControllers = self.childViewControllers;
    self.containerView.chooseIndex = self.currentTabIndex;
}

@end
