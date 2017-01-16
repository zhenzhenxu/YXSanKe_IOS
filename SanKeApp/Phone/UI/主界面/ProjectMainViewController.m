//
//  ProjectMainViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectMainViewController.h"
#import "YXDrawerController.h"
#import "PlayRecordViewController.h"
#import "ProjectContainerView.h"
#import "CourseViewController.h"
#import "ProjectNavRightView.h"
#import "FilterSelectionView.h"
#import "ChannelTabRequest.h"
@interface ProjectMainViewController ()
@property (nonatomic, strong) ChannelTabRequest *tabRequest;
@property (nonatomic, strong) ProjectContainerView *containerView;
@end

@implementation ProjectMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"主界面";
    [self setupRightWithTitle:@"播放记录"];
    [self setupUI];
    [self setupLeftNavView];
    [self setupRightNavView];
    [self requestForChannelTab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[ProjectContainerView alloc]initWithFrame:self.view.bounds];
    self.containerView.hidden = YES;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.containerView];
}

- (void)setupLeftNavView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32.0f, 32.0f);
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"" object:nil]subscribeNext:^(id x) {
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"" object:nil]subscribeNext:^(id x) {
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    }];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [YXDrawerController showDrawer];
    }];
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 16;
    button.clipsToBounds = YES;
    [self setupLeftWithCustomView:button];
}
- (void)setupRightNavView {
    ProjectNavRightView *rightView = [[ProjectNavRightView alloc] init];
    WEAK_SELF
    [rightView setProjectNavButtonLeftBlock:^{
        STRONG_SELF
        [self showFilterSelectionView];
    }];
    [rightView setProjectNavButtonRightBlock:^{
        STRONG_SELF;
        PlayRecordViewController *vc = [[PlayRecordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self setupRightWithCustomView:rightView];
}
- (void)showContainerView:(NSArray *)tabs {
    self.containerView.hidden = NO;
    for (CourseViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (ChannelTabRequestItem_Data_Tab *tab in tabs) {
        CourseTabItem *item = [[CourseTabItem alloc] init];
        item.name = [NSString stringWithFormat:@"%@",tab.catname];
        item.tabId = tab.catid;
        CourseViewController *vc = [[CourseViewController alloc] init];
        vc.tabItem = item;
        [self addChildViewController:vc];
    }
    self.containerView.childViewControllers = self.childViewControllers;
}
- (void)showFilterSelectionView {
    FilterSelectionView *v = [[FilterSelectionView alloc]init];
    AlertView *alert = [[AlertView alloc]init];
    alert.hideWhenMaskClicked = YES;
    alert.contentView = v;
    [alert setHideBlock:^(AlertView *view) {
        [UIView animateWithDuration:0.3 animations:^{
            [v mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_right);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*300/375);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(view.mas_right);
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*300/375);
            }];
            [view layoutIfNeeded];
        }];
    }];
}
#pragma mark - request
- (void)requestForChannelTab {
    if (self.tabRequest) {
        [self.tabRequest stopRequest];
    }

    ChannelTabRequest *request = [[ChannelTabRequest alloc] init];
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[ChannelTabRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            
        }else {
            ChannelTabRequestItem *item = retItem;
            [self showContainerView:item.data.tab];
        }
    }];
    self.tabRequest = request;
}
@end
