//
//  ChannelTabFilterRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ChannelTabFilterRequest.h"

@implementation ChannelTabFilterRequestItem_filter
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"filterID",@"items":@"subFilters"}];
}
@end
@implementation ChannelTabFilterRequestItem_category
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"categoryID",@"sub":@"subCategory"}];
}
@end
@implementation ChannelTabFilterRequestItem_data
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"items":@"filters"}];
}
@end
@implementation ChannelTabFilterRequestItem
@end

@implementation ChannelTabFilterRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/cascade"];
    }
    return self;
}
@end
