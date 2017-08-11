//
//  GetMarkDetailRequest.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetMarkDetailRequest.h"

@implementation GetMarkDetailRequestItem_Data
@end

@implementation GetMarkDetailRequestItem
@end

@implementation GetMarkDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/get_mark_detail"];
    }
    return self;
}
@end
