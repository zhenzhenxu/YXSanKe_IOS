//
//  UIViewController+YXAddtion.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "UIViewController+YXAddtion.h"

@implementation UIViewController (YXAddtion)
- (UIViewController *)visibleViewController{
    if(self.presentingViewController){
        return self;
    }
    else{
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        UIViewController *rootViewController = window.rootViewController;
        return [UIViewController getVisibleViewControllerFrom:rootViewController];
    }
}
+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIViewController getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIViewController getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIViewController getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end
