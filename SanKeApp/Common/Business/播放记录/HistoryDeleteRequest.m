//
//  HistoryDeleteRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HistoryDeleteRequest.h"

@implementation HistoryDeleteRequest

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"resource_id":@"resourceId"}];
}

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/history_delete"];
    }
    return self;
}

@end
