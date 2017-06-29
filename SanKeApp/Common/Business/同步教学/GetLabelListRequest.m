//
//  GetLabelListRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetLabelListRequest.h"

@implementation GetLabelListRequestItem_Element
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementID"}];
}

- (NSArray *)subNodes{
    return self.items;
}
@end

@implementation GetLabelListRequestItem_Data
- (NSArray *)subNodes{
    return self.elements;
}
@end

@implementation GetLabelListRequestItem
@end

@implementation GetLabelListRequest
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"labelID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/get_label_list"];
    }
    return self;
}
@end
