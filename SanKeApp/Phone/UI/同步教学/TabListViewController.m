//
//  TabListViewController.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TabListViewController.h"
#import "TabViewController.h"
#import "TabContainerView.h"
#import "TeachingMutiTabView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width

@interface TabListViewController ()<UIScrollViewDelegate>
//@property (nonatomic, strong) ChannelTabFilterRequest *selectionrequest;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) TeachingMutiTabView *topScrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property(nonatomic,strong) TabViewController *chooseViewController;

@end

@implementation TabListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    [self setupUI];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kStageSubjectDidChangeNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self setupTitle];
    }];

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

#pragma mark
- (void)setupUI {

    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1/[UIScreen mainScreen].scale)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.view addSubview:self.lineView];
    
    self.topScrollView = [[TeachingMutiTabView alloc]initWithFrame:CGRectMake(0, 1/[UIScreen mainScreen].scale, kScreenWidth, 44)];
    self.topScrollView.tabArray = self.tabArray;
//    self.topScrollView.currentTab = self.tabArray[self.currentTabIndex];
    self.topScrollView.currentTabIndex = self.currentTabIndex;
    [self.view addSubview:self.topScrollView];
    WEAK_SELF
    [self.topScrollView setClickTabButtonBlock:^{
        STRONG_SELF
        NSInteger currentIndex = self.topScrollView.currentTabIndex;
        self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*currentIndex, 0);
        self.chooseViewController = self.childViewControllers[currentIndex];
        if (self.chooseViewController.view.superview)
            return;
        self.chooseViewController.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*currentIndex, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
        self.chooseViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.bottomScrollView addSubview:self.chooseViewController.view];
    }];
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topScrollView.frame.origin.y+self.topScrollView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.topScrollView.frame.size.height)];
    self.bottomScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    [self.view addSubview:self.bottomScrollView];
    
    [self.tabArray enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Label * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TabViewController *vc = [[TabViewController alloc] init];
        vc.label = obj;
        [self addChildViewController:vc];
        if (idx == self.currentTabIndex) {
            vc.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*idx, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
            vc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.bottomScrollView addSubview:vc.view];
            self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*idx, 0);
            self.topScrollView.contentOffset = CGPointMake(0, 0);
            self.chooseViewController = vc;
        }
    }];
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.tabArray.count, self.bottomScrollView.frame.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.topScrollView.currentTabIndex = index;
    self.chooseViewController = self.childViewControllers[index];
    if (self.chooseViewController.view.superview) return;
    self.chooseViewController.view.frame = CGRectMake(self.bottomScrollView.frame.size.width*index, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
    self.chooseViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.bottomScrollView addSubview:self.chooseViewController.view];
    
}


@end
