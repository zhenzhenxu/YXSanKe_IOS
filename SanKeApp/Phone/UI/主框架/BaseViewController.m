//
//  BaseViewController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2016/12/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigationBarController.h"
#import "YXPromtController.h"
#import "YXDrawerController.h"

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *vcArray = self.navigationController.viewControllers;
    if (!isEmpty(vcArray)) {
        if (vcArray[0] != self) {
            [self setupLeftBack];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@", self.class);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UINavigationController *)navigationController{
    UINavigationController *navi = [super navigationController];
    if (!navi) {
        YXDrawerViewController *drawerVC = [YXDrawerController drawer];
        if ([drawerVC.paneViewController isKindOfClass:[UINavigationController class]]) {
            navi = (UINavigationController *)drawerVC.paneViewController;
        }
    }
    return navi;
}

#pragma mark - Navi Left
- (void)setupLeftBack{
    [self setupLeftWithImageNamed:@"返回按钮" highlightImageNamed:@"返回按钮点击态"];
}

- (void)setupLeftWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName{
    WEAK_SELF
    [NavigationBarController setLeftWithNavigationItem:self.navigationItem imageName:imageName highlightImageName:highlightImageName action:^{
        STRONG_SELF
        [self naviLeftAction];
    }];
}

- (void)setupLeftWithCustomView:(UIView *)view{
    [NavigationBarController setLeftWithNavigationItem:self.navigationItem customView:view];
}

- (void)naviLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navi Right
- (void)setupRightWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName{
    WEAK_SELF
    [NavigationBarController setRightWithNavigationItem:self.navigationItem imageName:imageName highlightImageName:highlightImageName action:^{
        STRONG_SELF
        [self naviRightAction];
    }];
}

- (void)setupRightWithCustomView:(UIView *)view{
    [NavigationBarController setRightWithNavigationItem:self.navigationItem customView:view];
}

- (void)setupRightWithTitle:(NSString *)title{
    WEAK_SELF
    [NavigationBarController setRightWithNavigationItem:self.navigationItem title:title action:^{
        STRONG_SELF
        [self naviRightAction];
    }];
}

- (void)naviRightAction{
    
}

#pragma mark - 提示
- (void)startLoading{
    [NavigationBarController disableRightNavigationItem:self.navigationItem];
    [YXPromtController startLoadingInView:self.view];
}

- (void)stopLoading{
    [NavigationBarController enableRightNavigationItem:self.navigationItem];
    [YXPromtController stopLoadingInView:self.view];
}

- (void)showToast:(NSString *)text{
    [YXPromtController showToast:text inView:self.view];
}
#pragma mark - 网络数据处理
- (BOOL)handleRequestData:(UnhandledRequestData *)data {
    return [self handleRequestData:data inView:self.view];
}
- (BOOL)handleRequestData:(UnhandledRequestData *)data inView:(UIView *)view {
    [self.emptyView removeFromSuperview];
    [self.errorView removeFromSuperview];
    [self.dataErrorView removeFromSuperview];
    
    BOOL handled = NO;
    if (data.error) {
        if (data.localDataExist) {
            [YXPromtController showToast:data.error.localizedDescription inView:view];
        }else {
            if (data.error.code == ASIConnectionFailureErrorType || data.error.code == ASIRequestTimedOutErrorType) {//网络错误/请求超时
                [view addSubview:self.errorView];
                [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }else {
                [view addSubview:self.dataErrorView];
                [self.dataErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }
        }
        handled = YES;
    }else {
        if (!data.requestDataExist) {
            [view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            handled = YES;
        }
    }
    return handled;
    
}
@end
