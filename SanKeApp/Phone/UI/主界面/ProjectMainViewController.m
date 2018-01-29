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
#import "LunboPageRequest.h"
#import "FocusRotationView.h"
#import "YXWebViewController.h"
#import "SKTabBarController.h"

@interface ProjectMainViewController ()
@property (nonatomic, strong) ChannelTabRequest *tabRequest;
@property (nonatomic, strong) ProjectContainerView *containerView;
@property (nonatomic, strong) FocusRotationView *rotationView;
@property (nonatomic, strong) LunboPageRequest *pageRequest;
@property (nonatomic, strong) LunboPageItem_Data *itemData;
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
    [self setupObservers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForChannelTab) name:kStageSubjectDidChangeNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestForLunboPage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction {
    PlayRecordViewController *vc = [[PlayRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kTabBarDidSelectNotification object:nil]subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (self.navigationController == x.object) {
            [self requestForLunboPage];
        }
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    self.rotationView = [[FocusRotationView alloc] init];
    self.rotationView.hidden = YES;
    self.rotationView.backgroundColor = [UIColor clearColor];
    WEAK_SELF
    self.rotationView.focusRotationClickBlock = ^(NSInteger integer) {
        STRONG_SELF
        LunboPageItem_Data_Item *item = self.itemData.items[integer];
        YXWebViewController *VC = [[YXWebViewController alloc] init];
        VC.urlString = item.detail;
        VC.isUpdatTitle = YES;
        [self.navigationController pushViewController:VC animated:YES];
    };
    [self.view addSubview:self.rotationView];
    [self.rotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(120.0f);
    }];
    self.containerView = [[ProjectContainerView alloc]initWithFrame:self.view.bounds];
    self.containerView.hidden = YES;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.containerView];
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestForChannelTab];
    }];
    self.dataErrorView = [[DataErrorView alloc]init];
}
- (void)setupLunboContentView:(NSArray *)array {
    NSMutableArray *mutableArry = [[NSMutableArray alloc] initWithCapacity:4];
    WEAK_SELF
    [array enumerateObjectsUsingBlock:^(LunboPageItem_Data_Item *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.text = @"图片正在加载中";
        placeholderLabel.textColor = [UIColor colorWithHexString:@"999999"];
        placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
        [imageView addSubview:placeholderLabel];
        imageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imageView);
        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil && error == nil) {
                [placeholderLabel removeFromSuperview];
                imageView.backgroundColor = [UIColor clearColor];
            }else {
                placeholderLabel.text = @"图片加载失败";
            }
        }];
        [mutableArry addObject:imageView];
    }];
    self.rotationView.itemViewArray = mutableArry;
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

- (void)requestForLunboPage {
    LunboPageRequest *request = [[LunboPageRequest alloc] init];
    WEAK_SELF
    [request startRequestWithRetClass:[LunboPageItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        LunboPageItem *item = retItem;
        if (error) {
            return;
        }
        if (item.data.items.count == 0) {
            self.containerView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
            self.rotationView.hidden = YES;
        }else {
            self.containerView.frame = CGRectMake(0.0f, 150.0f, self.view.bounds.size.width, self.view.bounds.size.height - 150.0f);
            self.rotationView.hidden = NO;
            self.itemData = item.data;
            [self setupLunboContentView:item.data.items];
        }
    }];
    self.pageRequest = request;
}

@end
