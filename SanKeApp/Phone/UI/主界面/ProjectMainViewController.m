//
//  ProjectMainViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ProjectMainViewController.h"
#import "PlayRecordViewController.h"
#import "ProjectContainerView.h"
#import "CourseViewController.h"
#import "ChannelTabRequest.h"

@interface ProjectMainViewController ()
@property (nonatomic, strong) ChannelTabRequest *tabRequest;
@property (nonatomic, strong) ProjectContainerView *containerView;
@end

@implementation ProjectMainViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setupUI];
    [self setupRightWithImageNamed:@"历史记录-2" highlightImageNamed:nil];
    [self requestForChannelTab];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForChannelTab) name:kStageSubjectDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction {
    PlayRecordViewController *vc = [[PlayRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)showContainerView:(NSArray *)categorys {
    self.containerView.hidden = NO;
    for (CourseViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (ChannelTabRequestItem_Data_Category *cat in categorys) {
        CourseVideoItem *item = [[CourseVideoItem alloc] init];
        item.name = [NSString stringWithFormat:@"%@",cat.cateName];
        item.catID = cat.catId;
        item.moduleId = cat.moduleId;
        item.fromType = 1;
        if ([cat.cateName isEqualToString:@"教材新在哪里"]) {
            item.code = @"xznl_tab";
        } else if ([cat.cateName isEqualToString:@"关键点位引领"]) {
            item.code = @"gjdw_tab";
        } else if ([cat.cateName isEqualToString:@"课例研磨示例"]) {
            item.code = @"klym_tab";
        }
        CourseViewController *vc = [[CourseViewController alloc] init];
        vc.videoItem = item;
        [self addChildViewController:vc];
    }
    WEAK_SELF
    [self.containerView setClickTabButtonBlock:^{
        STRONG_SELF
        [self.containerView.chooseViewController firstPageFetch];
    }];
    self.containerView.childViewControllers = self.childViewControllers;
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
