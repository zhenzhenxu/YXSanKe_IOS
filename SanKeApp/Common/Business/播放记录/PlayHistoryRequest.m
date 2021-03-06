//
//  PlayHistoryRequest.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PlayHistoryRequest.h"
@implementation PlayHistoryRequestItem_Data_History
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"itemID"}];
}
@end
@implementation PlayHistoryRequestItem_Data
@end
@implementation PlayHistoryRequestItem
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"videoID"}];
}
@end
@implementation PlayHistoryRequest
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"page_num":@"pageNum",
                                                       @"page_size":@"pageSize"}];
}

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/get_history"];
    }
    return self;
}
@end
