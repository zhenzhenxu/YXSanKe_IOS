//
//  QAQuestionListFetcher.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAQuestionListFetcher.h"
#import "QAQuestionListRequest.h"

@interface QAQuestionListFetcher()
@property (nonatomic, strong) QAQuestionListRequest *request;
@end

@implementation QAQuestionListFetcher
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[QAQuestionListRequest alloc]init];
    self.request.from = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.m = [NSString stringWithFormat:@"%@",@(self.pageSize)];
    self.request.sort_field = self.sort_field;
    WEAK_SELF
    [self.request startRequestWithRetClass:[QAQuestionListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        QAQuestionListRequestItem *item = (QAQuestionListRequestItem *)retItem;
        self.lastID += item.data.askPage.elements.count;
        BLOCK_EXEC(aCompleteBlock,item.data.askPage.totalElements.integerValue,item.data.askPage.elements,nil)
    }];
}
@end
