//
//  YXPostRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@implementation YXPostRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.token = [UserManager sharedInstance].userModel.token;
        self.ver = [SKConfigManager sharedInstance].clientVersion;
        self.os = @"ios";
        if ([UserManager sharedInstance].userModel.isAnonymous) {
            self.is_anonymous = @"1";
        }
    }
    return self;
}



@end
