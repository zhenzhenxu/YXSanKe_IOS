//
//  YXUploadRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUploadRequest.h"

@implementation YXUploadRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.token = [UserManager sharedInstance].userModel.token;
        if ([UserManager sharedInstance].userModel.isAnonymous) {
            self.is_anonymous = @"1";
        }
    }
    return self;
}

@end
