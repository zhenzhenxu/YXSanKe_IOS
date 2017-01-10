//
//  UIView+ViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)yx_viewController
{
    for (UIView *view = self; view; view = view.superview) {
        if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)view.nextResponder;
        }
    }
    return nil;
}

@end
