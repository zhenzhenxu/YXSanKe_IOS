//
//  UpdateInfoRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpdateInfoRequest.h"

@implementation UpdateInfoRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/user/update_info"];
    }
    return self;
}

@end
