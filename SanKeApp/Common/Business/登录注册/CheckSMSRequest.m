//
//  CheckSMSRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CheckSMSRequest.h"

@implementation CheckSMSRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/passport/check_sms"];
    }
    return self;
}

@end
