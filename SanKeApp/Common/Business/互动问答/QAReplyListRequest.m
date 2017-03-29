//
//  QAReplyListRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyListRequest.h"

@implementation QAReplyListRequestItem_LikeInfo

@end

@implementation QAReplyListRequestItem_Element
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementID"}];
}
@end

@implementation QAReplyListRequestItem_AnswerPage

@end

@implementation QAReplyListRequestItem_Data

@end

@implementation QAReplyListRequestItem

@end

@implementation QAReplyListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/hddy/get_answers"];
        self.biz_id = [NSString stringWithFormat:@"%@_%@",[UserManager sharedInstance].userModel.stageID,[UserManager sharedInstance].userModel.subjectID];
    }
    return self;
}
@end
