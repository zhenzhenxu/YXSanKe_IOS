//
//  GetBookInfoRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetBookInfoRequest.h"

@implementation GetBookInfoRequestItem_MarkerLine
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"lineID"}];
}
@end

@implementation GetBookInfoRequestItem_MarkerIcon
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"iconID"}];
}
@end

@implementation GetBookInfoRequestItem_Marker
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"markerID"}];
}
@end

@implementation GetBookInfoRequestItem_Mark
@end

@implementation GetBookInfoRequestItem_Page
+ (JSONKeyMapper *)keyMapper {
     return [[JSONKeyMapper alloc] initWithDictionary:@{@"idx":@"pageIndex"}];
}
@end

@implementation GetBookInfoRequestItem_Label
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"labelID"}];
}
@end

@implementation GetBookInfoRequestItem_Course
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"courseID"}];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
@end

@implementation GetBookInfoRequestItem_Unit
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"unitID",
                                                       @"items":@"courses"
                                                       }];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}
@end

@implementation GetBookInfoRequestItem_Volum
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"volumID",
                                                       @"items":@"units"
                                                       }];
}
@end

@implementation GetBookInfoRequestItem_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"items":@"volums"}];
}
@end

@implementation GetBookInfoRequestItem
//+ (GetBookInfoRequestItem *)mockGetBookInfoRequestItem {
//    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"GetBookInfo.json" ofType:nil];
//    NSString *json = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
//    JSONModelError *err = nil;
//    return [[GetBookInfoRequestItem alloc] initWithString:json error:&err];
//}
@end

@implementation GetBookInfoRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/get_book_info"];
        self.biz_id = [NSString stringWithFormat:@"%@_%@",[UserManager sharedInstance].userModel.stageID,[UserManager sharedInstance].userModel.subjectID];
    }
    return self;
}

@end
