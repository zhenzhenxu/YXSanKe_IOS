//
//  UpgradeManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpgradeManager.h"
#import "YXInitRequest.h"

@interface UpgradeManager()
@property (nonatomic, strong) YXInitRequest *request;
@end

@implementation UpgradeManager
+ (UpgradeManager *)sharedInstance {
    static dispatch_once_t once;
    static UpgradeManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[UpgradeManager alloc] init];
    });
    
    return sharedInstance;
}

+ (void)checkForUpgrade {
    UpgradeManager *manager = [UpgradeManager sharedInstance];
    [manager.request stopRequest];
    manager.request = [[YXInitRequest alloc] init];
    [manager.request startRequestWithRetClass:[YXInitRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        [manager showUpgradeIfNeededWithItem:retItem];
    }];
}

- (void)showUpgradeIfNeededWithItem:(YXInitRequestItem *)item {
    if (!item || item.body.count <= 0) {
        return;
    }
    
    YXInitRequestItem_Body *body = item.body[0];
    
    if ([body isTest]) { //测试环境
#ifndef DEBUG
        return;
#endif
    }
    if (![body.fileURL yx_isHttpLink]) { //http链接
        return;
    }
    
    if ([body isForce]) {
        [self showForceUpgradeWithBody:body];
    }else {
        [self showUnForceUpgradeWithBody:body];
    }
}

- (void)showForceUpgradeWithBody:(YXInitRequestItem_Body *)body {
    SKAlertView *alert = [[SKAlertView alloc]init];
    alert.title = body.title;
    alert.hideWhenButtonClicked = NO;
    WEAK_SELF
    [alert addButtonWithTitle:@"升级" style:SKAlertButtonStyle_Alone action:^{
        STRONG_SELF
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
    }];
    [alert show];
}

- (void)showUnForceUpgradeWithBody:(YXInitRequestItem_Body *)body {
    SKAlertView *alert = [[SKAlertView alloc]init];
    alert.title = body.title;
    WEAK_SELF
    [alert addButtonWithTitle:@"取消" style:SKAlertButtonStyle_Cancel action:nil];
    [alert addButtonWithTitle:@"升级" style:SKAlertButtonStyle_Alone action:^{
        STRONG_SELF
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
    }];
    [alert show];
}

@end
