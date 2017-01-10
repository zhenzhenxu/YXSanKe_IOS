//
//  YXPromtController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXPromtController.h"
#import "YXLoadView.h"
@implementation YXPromtController

+ (void)startLoadingInView:(UIView *)view{
    if ([MBProgressHUD HUDForView:view]) {
        return;
    }
//    [MBProgressHUD showHUDAddedTo:view animated:YES];
    YXLoadView *loadView = [[YXLoadView alloc] initWithFrame:CGRectMake(0, 0, 45.0f, 45.0f)];
    loadView.layer.cornerRadius = 22.5f;
    loadView.layer.borderColor = [UIColor colorWithHexString:@"b3bdc6"].CGColor;
    loadView.layer.borderWidth = 4.0f;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = loadView;
    hud.color = [UIColor clearColor];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [loadView startAnimate];
    
}

+ (void)stopLoadingInView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)showToast:(NSString *)text inView:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:view animated:NO];    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

@end
