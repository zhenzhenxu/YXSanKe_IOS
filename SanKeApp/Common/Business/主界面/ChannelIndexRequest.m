//
//  ChannelIndexRequest.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ChannelIndexRequest.h"
@implementation ChannelIndexRequestItem_Data_Elements
@end
@implementation ChannelIndexRequestItem_Data
@end
@implementation ChannelIndexRequestItem
@end
@implementation ChannelIndexRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@""];
    }
    return self;
}
@end
