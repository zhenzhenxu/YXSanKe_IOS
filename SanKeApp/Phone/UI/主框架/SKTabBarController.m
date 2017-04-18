//
//  SKTabBarController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SKTabBarController.h"
#import "TeachingMainViewController.h"

@interface SKTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSUInteger oldSelectedIndex;
@end

@implementation SKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)topViewController {
    UINavigationController *navi = self.selectedViewController;
    if ([navi isKindOfClass:[UINavigationController class]]) {
        return navi.topViewController;
    }
    return navi;
}

- (BOOL)shouldAutorotate {
    return [self topViewController].shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self topViewController].supportedInterfaceOrientations;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [[self topViewController] viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
- (BOOL)prefersStatusBarHidden {
    return [[self topViewController] prefersStatusBarHidden];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *vc = (SKNavigationController *)viewController.childViewControllers.firstObject;
    if ([vc isKindOfClass:[TeachingMainViewController class]]) {
        BaseViewController *oldVc = self.viewControllers[self.oldSelectedIndex].childViewControllers.firstObject;
        [oldVc showToast:@"该功能暂未开放"];
        return NO;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.oldSelectedIndex = self.selectedIndex;
}
@end
