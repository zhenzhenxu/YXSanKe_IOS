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
#import "ChannelTabFilterRequest.h"

@interface ProjectMainViewController ()
@property (nonatomic, strong) ChannelTabRequest *tabRequest;
@property (nonatomic, strong) ProjectContainerView *containerView;
@property (nonatomic, strong) ChannelTabFilterRequest *selectionrequest;
@end

@implementation ProjectMainViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setupUI];
    [self setupLeftNavView];
    [self setupRightNavView];
    [self requestForChannelTab];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForChannelTab) name:kStageSubjectDidChangeNotification object:nil];
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
    NSString *icon = [UserManager sharedInstance].userModel.portraitUrl;
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"大头像"]];
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"成功修改头像的通知" object:nil]subscribeNext:^(id x) {
//        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
//    }];//现在用户头像不能修改,先注释掉,待后续修改头像的时候再加上
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [YXDrawerController showDrawer];
    }];
    button.layer.cornerRadius = 16;
    button.clipsToBounds = YES;
    [self setupLeftWithCustomView:button];
}
- (void)setupRightNavView {
    ProjectNavRightView *rightView = [[ProjectNavRightView alloc] init];
    WEAK_SELF
    [rightView setProjectNavButtonLeftBlock:^{
        STRONG_SELF
        [self requestSelection];
    }];
    [rightView setProjectNavButtonRightBlock:^{
        STRONG_SELF;
        PlayRecordViewController *vc = [[PlayRecordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self setupRightWithCustomView:rightView];
}
- (void)showContainerView:(NSArray *)categorys {
    self.containerView.hidden = NO;
    for (CourseViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (ChannelTabRequestItem_Data_Category *cat in categorys) {
        CourseVideoItem *item = [[CourseVideoItem alloc] init];
        item.name = [NSString stringWithFormat:@"%@",cat.cateName];
        item.catID = cat.catId;
        item.fromType = 0;
        CourseViewController *vc = [[CourseViewController alloc] init];
        vc.videoItem = item;
        [[vc rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
            NSLog(@"%@", item.catID);
        } error:^(NSError *error) {
            
        }];
        [self addChildViewController:vc];
    }
    self.containerView.childViewControllers = self.childViewControllers;
}
- (void)showFilterSelectionView {
    FilterSelectionView *v = self.containerView.chooseViewController.selectionView;
    if (v == nil) {
        v = [[FilterSelectionView alloc]init];
    }
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
    [v setCompleteBlock:^(NSString *filterString) {
        [alert hide];
    }];
}
#pragma mark - request
- (void)requestSelection{
    [self.selectionrequest stopRequest];
    self.selectionrequest = [ChannelTabFilterRequest new];
    self.selectionrequest.catid = self.containerView.chooseViewController.videoItem.catID;
    [self startLoading];
    WEAK_SELF
    [self.selectionrequest startRequestWithRetClass:[ChannelTabFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            return;
        }
        if (self.containerView.chooseViewController.selectionView == nil) {
            self.containerView.chooseViewController.selectionView = [[FilterSelectionView alloc]init];
        }
        ChannelTabFilterRequestItem *item = retItem;
        self.containerView.chooseViewController.selectionView.data = item.data;
        [self showFilterSelectionView];
    }];
}
    
- (void)requestForChannelTab {
    UserModel *model = [UserManager sharedInstance].userModel;
    [StageSubjectDataManager fetchStageSubjectWithStageID:model.stageID subjectID:model.subjectID completeBlock:^(FetchStageSubjectRequestItem_stage *stage, FetchStageSubjectRequestItem_subject *subject) {
        NSString *title = [stage.name stringByAppendingString:subject.name];
        self.navigationItem.title = title;
    }];
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
            [self showContainerView:item.data.category];
        }
    }];
    self.tabRequest = request;
}
@end
