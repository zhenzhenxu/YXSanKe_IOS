//
//  SendSMSRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SendSMSRequest.h"

@implementation SendSMSRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/passport/send_sms"];
    }
    return self;
}

@end
