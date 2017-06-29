//
//  ResourceDetailRequest.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceDetailRequest.h"

@implementation ResourceDetailRequestItem_Data

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"createTime.time" : @"createTime"}];
}

@end

@implementation ResourceDetailRequestItem
@end

@implementation ResourceDetailRequest

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"resourceID"}];
}

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/get_label_resource"];
    }
    return self;
}

@end
