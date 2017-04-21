//
//  QAQuestionListRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionListRequest.h"

@implementation QAQuestionListRequestItem_Attachment

@end

@implementation QAQuestionListRequestItem_Element
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementID"}];
}
- (void)setContent:(NSString<Optional> *)content {
    NSMutableAttributedString  *attrStr = [[NSMutableAttributedString alloc] initWithData:[content?:@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _content = attrStr.string;
}
@end

@implementation QAQuestionListRequestItem_AskPage

@end

@implementation QAQuestionListRequestItem_Data

@end

@implementation QAQuestionListRequestItem

@end

@implementation QAQuestionListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/hddy/get_asks"];
        self.biz_id = [NSString stringWithFormat:@"%@_%@",[UserManager sharedInstance].userModel.stageID,[UserManager sharedInstance].userModel.subjectID];
    }
    return self;
}
@end
