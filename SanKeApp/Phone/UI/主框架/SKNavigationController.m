//
//  SKNavigationController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2016/12/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "SKNavigationController.h"

@interface SKNavigationController ()

@end

@implementation SKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 导航背景
    [self.navigationBar setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = YES;
    // 标题样式
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithHexString:@"333333"], NSForegroundColorAttributeName,
                                                [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                nil]];
    
    UIView *barBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [self.navigationBar addSubview:barBgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [YXDrawerController hideDrawer];
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.topViewController.view.userInteractionEnabled = NO;
    [super pushViewController:viewController animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
        if (navigationController.viewControllers.count ==1) {
            self.interactivePopGestureRecognizer.enabled =NO;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
