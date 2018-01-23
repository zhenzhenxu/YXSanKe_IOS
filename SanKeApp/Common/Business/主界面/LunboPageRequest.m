//
//  LunboPageRequest.m
//  SanKeApp
//
//  Created by 郑小龙 on 2018/1/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "LunboPageRequest.h"
@implementation LunboPageItem_Data_Item
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"itemId"}];
}
@end

@implementation LunboPageItem_Data
@end

@implementation LunboPageItem
@end

@implementation LunboPageRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/lunbo_page"];
    }
    return self;
}
@end
