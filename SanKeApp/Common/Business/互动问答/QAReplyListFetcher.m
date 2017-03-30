//
//  QAReplyListFetcher.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAReplyListFetcher.h"
#import "QAReplyListRequest.h"

@interface QAReplyListFetcher()
@property (nonatomic, strong) QAReplyListRequest *request;
@end

@implementation QAReplyListFetcher
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[QAReplyListRequest alloc]init];
    self.request.from = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.m = [NSString stringWithFormat:@"%@",@(self.pageSize)];
    self.request.ask_id = self.ask_id;
    WEAK_SELF
    [self.request startRequestWithRetClass:[QAReplyListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        QAReplyListRequestItem *item = (QAReplyListRequestItem *)retItem;
        self.lastID += item.data.answerPage.elements.count;
        BLOCK_EXEC(aCompleteBlock,item.data.answerPage.totalElements.integerValue,item.data.answerPage.elements,nil)
        
        NSDictionary *infoDic = @{kQAQuestionIDKey:self.ask_id,
                                  kQAQuestionReplyCountKey:item.data.answerPage.totalElements};
        [[NSNotificationCenter defaultCenter]postNotificationName:kQAQuestionInfoUpdateNotification object:nil userInfo:infoDic];
    }];
}
@end
