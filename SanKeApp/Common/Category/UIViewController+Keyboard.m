//
//  UIViewController+Keyboard.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/3/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "UIViewController+Keyboard.h"

@implementation UIViewController (Keyboard)

- (void)yx_hideKeyboard{
    [self yx_resignFirstResponderForView:self.view];
}
- (void)yx_resignFirstResponderForView:(UIView *)view{
    if (([view isKindOfClass:[UITextField class]]||[view isKindOfClass:[UITextView class]])&&[view isFirstResponder]) {
        [view resignFirstResponder];
        return;
    }
    for (UIView *subview in view.subviews) {
        [self yx_resignFirstResponderForView:subview];
    }
}

@end
