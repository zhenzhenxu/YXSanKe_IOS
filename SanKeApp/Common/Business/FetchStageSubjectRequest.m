//
//  FetchStageSubjectRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FetchStageSubjectRequest.h"

@implementation FetchStageSubjectRequestItem_subject
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"subjectID"}];
}
@end
@implementation FetchStageSubjectRequestItem_stage
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"stageID",@"items":@"subjects"}];
}
@end
@implementation FetchStageSubjectRequestItem_category
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"sub":@"subCategory"}];
}
@end
@implementation FetchStageSubjectRequestItem_data
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"items":@"stages"}];
}
@end
@implementation FetchStageSubjectRequestItem

@end

@interface FetchStageSubjectRequest()
@property (nonatomic, strong) NSString *code;
@end
@implementation FetchStageSubjectRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/cascade"];
        self.code = @"stage_subject";
    }
    return self;
}
@end
