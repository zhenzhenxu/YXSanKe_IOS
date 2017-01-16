//
//  UpgradeManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpgradeManager.h"
#import "YXInitRequest.h"
#import "UpgradeView.h"

@interface UpgradeManager()
@property (nonatomic, strong) YXInitRequest *request;
@property (nonatomic, strong) UpgradeView *upgradeView;
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
    [self showUpgradeWithBody:body];
}

- (void)showUpgradeWithBody:(YXInitRequestItem_Body *)body {
    self.upgradeView = [[UpgradeView alloc]init];
    self.upgradeView.isForce = body.isForce;
    WEAK_SELF
    [self.upgradeView setUpgradeButtonActionBlock:^{
        STRONG_SELF
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
    }];
    
    SKAlertView *alert = [[SKAlertView alloc]init];
    alert.maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    alert.contentView = self.upgradeView;
    [alert showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(275, 379));
        }];
    }];
}

@end
