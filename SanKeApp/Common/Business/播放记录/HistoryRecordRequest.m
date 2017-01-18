//
//  HistoryRecordRequest.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HistoryRecordRequest.h"
@implementation HistoryRecordRequestItem_Data
@end
@implementation HistoryRecordRequestItem
@end
@implementation HistoryRecordRequest
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"resource_id":@"resourceID",
                                                       @"watch_record":@"watchRecord",
                                                       @"total_time":@"totalTime"}];
}
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}
@end
