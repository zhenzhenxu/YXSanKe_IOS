//
//  GetResListRequest.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetResListRequest.h"

@implementation GetResListRequestItem_Data_Element_Res
@end

@implementation GetResListRequestItem_Data_Element
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"elementID"}];
}
@end

@implementation GetResListRequestItem_Data
@end

@implementation GetResListRequestItem
@end

@implementation GetResListRequest

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"moduleId"}];
}

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/gjjy/get_res_list"];
    }
    return self;
}
@end
