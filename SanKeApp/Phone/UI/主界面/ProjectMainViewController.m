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
@property (nonatomic, strong) ProjectNavRightView *projectNavRightView;
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
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    self.errorView = [[ErrorView alloc]init];
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self requestForChannelTab];
    }];
    self.dataErrorView = [[DataErrorView alloc]init];
}

- (void)setupLeftNavView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32.0f, 32.0f);
    button.layer.cornerRadius = 16;
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
    button.clipsToBounds = YES;
    NSString *icon = [UserManager sharedInstance].userModel.portraitUrl;
    [button sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"大头像"]];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUpdateHeadPortraitSuccessNotification object:nil]subscribeNext:^(id x) {
        DDLogDebug(@"主界面修改头像");
        [button sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.portraitUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    }];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [YXDrawerController showDrawer];
    }];
    
    [self setupLeftWithCustomView:button];
}
- (void)setupRightNavView {
    ProjectNavRightView *rightView = [[ProjectNavRightView alloc] init];
    self.projectNavRightView = rightView;
    WEAK_SELF
    [rightView setProjectNavButtonLeftBlock:^{
        STRONG_SELF
        [self.containerView.chooseViewController showFilterSelectionView];
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
        item.fromType = 1;
        CourseViewController *vc = [[CourseViewController alloc] init];
        vc.videoItem = item;
        vc.projectNavRightView = self.projectNavRightView;
        [self addChildViewController:vc];
    }
    WEAK_SELF
    [self.containerView setClickTabButtonBlock:^{
        STRONG_SELF
        [self.containerView.chooseViewController firstPageFetch];
    }];
    self.containerView.childViewControllers = self.childViewControllers;
    CourseViewController *vc = self.containerView.childViewControllers.firstObject;
    vc.projectNavRightView.leftButton.hidden = YES;

}

#pragma mark - request
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
        
        ChannelTabRequestItem *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = item.data.category.count > 0;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        
        [self showContainerView:item.data.category];
    }];
    self.tabRequest = request;
}
@end
