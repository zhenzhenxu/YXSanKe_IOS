//
//  QAQuestionDetailRequest.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionDetailRequest.h"

@implementation QAQuestionDetailRequestItem_Attachment
@end

@implementation QAQuestionDetailRequestItem_Ask
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"askID"}];
}

- (void)setContent:(NSString<Optional> *)content {
    NSMutableAttributedString  *attrStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _content = attrStr.string;
}
@end

@implementation QAQuestionDetailRequestItem_Data

@end

@implementation QAQuestionDetailRequestItem

@end

@implementation QAQuestionDetailRequest
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"questionID"}];
}

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/hddy/view"];
        self.biz_id = [NSString stringWithFormat:@"%@_%@",[UserManager sharedInstance].userModel.stageID,[UserManager sharedInstance].userModel.subjectID];
    }
    return self;
}
@end
