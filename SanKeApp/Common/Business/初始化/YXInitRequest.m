//
//  YXInitRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/8/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXInitRequest.h"

@implementation YXInitRequestItem_Property

@end

@implementation YXInitRequestItem_Body

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"iid"}];
}

- (BOOL)isTest
{
    if ([self.targetenv isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isForce
{
    if ([self.upgradetype isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end

@implementation YXInitRequestItem

@end

@implementation YXInitRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.token = nil;
        _productLine = @"3";
        _did = [SKConfigManager sharedInstance].deviceID;
        _brand = [SKConfigManager sharedInstance].deviceType;
        [self setCurrentNetType];
        
        _osModel = [UIDevice currentDevice].model;
        _appVersion = [SKConfigManager sharedInstance].clientVersion;
        _content = @"";
        _operType = @"app.upload.log";
#warning 稍后需要放开
//        _phone = [YXUserManager sharedManager].userModel.mobile;
        _remoteIp = @"";
        _mode = [SKConfigManager sharedInstance].mode;
        self.urlHead = [SKConfigManager sharedInstance].initializeUrl;
    }

    return self;
}

- (void)setCurrentNetType
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus]) {
        case ReachableViaWiFi:
            _nettype = @"1";
            break;
        case ReachableViaWWAN:
            _nettype = @"0";
            break;
        case NotReachable:
        default:
            break;
    }
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"os":@"osModel"}];
}

@end

