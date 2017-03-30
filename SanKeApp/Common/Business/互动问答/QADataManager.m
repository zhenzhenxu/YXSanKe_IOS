//
//  QADataManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QADataManager.h"

NSString * const kQAQuestionInfoUpdateNotification = @"kQAQuestionInfoUpdateNotification";
NSString * const kQAReplyInfoUpdateNotification = @"kQAReplyInfoUpdateNotification";

NSString * const kQAQuestionIDKey = @"kQAQuestionIDKey";
NSString * const kQAQuestionReplyCountKey = @"kQAQuestionReplyCountKey";
NSString * const kQAQuestionBrowseCountKey = @"kQAQuestionBrowseCountKey";

NSString * const kQAReplyIDKey = @"kQAReplyIDKey";
NSString * const kQAReplyFavorCountKey = @"kQAReplyFavorCountKey";

@interface QADataManager()
@property (nonatomic, strong) QAQuestionDetailRequest *questionDetailRequest;
@property (nonatomic, strong) QAReplyFavorRequest *replyFavorRequest;
@end

@implementation QADataManager
+ (QADataManager *)sharedInstance {
    static dispatch_once_t once;
    static QADataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[QADataManager alloc] init];
    });
    
    return sharedInstance;
}

+ (void)requestQuestionDetailWithID:(NSString *)questionID completeBlock:(void(^)(QAQuestionDetailRequestItem *item,NSError *error))completeBlock {
    QADataManager *manager = [QADataManager sharedInstance];
    [manager.questionDetailRequest stopRequest];
    manager.questionDetailRequest = [[QAQuestionDetailRequest alloc]init];
    manager.questionDetailRequest.questionID = questionID;
    WEAK_SELF
    [manager.questionDetailRequest startRequestWithRetClass:[QAQuestionDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error)
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil)
        QAQuestionDetailRequestItem *item = (QAQuestionDetailRequestItem *)retItem;
        NSDictionary *infoDic = @{kQAQuestionIDKey:questionID,
                                  kQAQuestionReplyCountKey:item.data.ask.answerNum,
                                  kQAQuestionBrowseCountKey:item.data.ask.viewNum};
        [[NSNotificationCenter defaultCenter]postNotificationName:kQAQuestionInfoUpdateNotification object:nil userInfo:infoDic];
    }];
}

+ (void)requestReplyFavorWithID:(NSString *)answerID completeBlock:(void(^)(QAReplyFavorRequestItem *item,NSError *error))completeBlock {
    QADataManager *manager = [QADataManager sharedInstance];
    [manager.replyFavorRequest stopRequest];
    manager.replyFavorRequest = [[QAReplyFavorRequest alloc]init];
    manager.replyFavorRequest.answer_id = answerID;
    WEAK_SELF
    [manager.replyFavorRequest startRequestWithRetClass:[QAReplyFavorRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error)
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil)
        QAReplyFavorRequestItem *item = (QAReplyFavorRequestItem *)retItem;
        [[NSNotificationCenter defaultCenter]postNotificationName:kQAReplyInfoUpdateNotification object:nil userInfo:@{kQAReplyIDKey:answerID,kQAReplyFavorCountKey:item.data.likeNum}];
    }];
}

@end
