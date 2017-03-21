//
//  YXSSOAuthManager.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/9/23.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXSSOAuthManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface YXSSOAuthManager ()

@property (nonatomic, strong) TencentOAuth *oauth;

@end

@implementation YXSSOAuthManager

+ (instancetype)sharedManager
{
    static YXSSOAuthManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YXSSOAuthManager alloc] init];
    });
    return sharedManager;
}

- (void)registerWXApp
{
    [WXApi registerApp:[SKConfigManager sharedInstance].YXSSOAuthWeixinAppid];
}

- (void)registerQQApp
{
    self.oauth = [[TencentOAuth alloc] initWithAppId:[SKConfigManager sharedInstance].YXSSOAuthQQAppid andDelegate:nil];
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    if ([TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [WXApi handleOpenURL:url delegate:nil];
}

@end
