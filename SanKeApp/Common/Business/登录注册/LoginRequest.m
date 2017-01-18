//
//  LoginRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/passport/login"];
    }
    return self;
}
@end
