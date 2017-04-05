//
//  QACreateAnswerRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QACreateAnswerRequest.h"

@implementation QACreateAnswerRequest

- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[SKConfigManager sharedInstance].server stringByAppendingString:@"app/sanke/hddy/create_answer"];
        self.biz_id = [NSString stringWithFormat:@"%@_%@",[UserManager sharedInstance].userModel.stageID,[UserManager sharedInstance].userModel.subjectID];
    }
    return self;
}

@end
