//
//  SKTabBarController.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SKTabBarController.h"

@interface SKTabBarController ()

@end

@implementation SKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
