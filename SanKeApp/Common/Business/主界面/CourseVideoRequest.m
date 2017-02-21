//
//  CourseVideoRequest.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseVideoRequest.h"
@implementation CourseVideoRequestItem_Data_Elements
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end
@implementation CourseVideoRequestItem_Data
@end
@implementation CourseVideoRequestItem
@end
@implementation CourseVideoRequest
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"filter_id":@"filterID",
                                                       @"last_id":@"lastID",
                                                       @"catid":@"catID",
                                                       @"from_type":@"fromType",
                                                       @"last_id":@"lastID",
                                                       @"page_size":@"pageSize"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/user/get_videos"];
    }
    return self;
}

@end
