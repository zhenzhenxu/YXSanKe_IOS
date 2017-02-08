//
//  ChannelTabRequest.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ChannelTabRequest.h"
@implementation ChannelTabRequestItem_Data_Category
@end
@implementation ChannelTabRequestItem_Data
@end
@implementation ChannelTabRequestItem
@end
@implementation ChannelTabRequest
- (instancetype)init {
    if (self = [super init]) {
       self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/pd_tab"]; 
    }
    return self;
}
@end
