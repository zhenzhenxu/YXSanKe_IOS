//
//  QADataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAQuestionDetailRequest.h"
#import "QAReplyFavorRequest.h"
#import "QACreateAskRequest.h"
#import "QACreateAnswerRequest.h"

extern NSString * const kQAQuestionInfoUpdateNotification; // 问题信息更新通知
extern NSString * const kQAReplyInfoUpdateNotification; // 回复信息更新通知

// 问题信息通知的key
extern NSString * const kQAQuestionIDKey;
extern NSString * const kQAQuestionReplyCountKey;
extern NSString * const kQAQuestionBrowseCountKey;

// 回复信息通知的key
extern NSString * const kQAReplyIDKey;
extern NSString * const kQAReplyFavorCountKey;
extern NSString * const kQAReplyUserFavorKey;

@interface QADataManager : NSObject
//获取问题详情
+ (void)requestQuestionDetailWithID:(NSString *)questionID completeBlock:(void(^)(QAQuestionDetailRequestItem *item,NSError *error))completeBlock;
//喜欢某个回答
+ (void)requestReplyFavorWithID:(NSString *)answerID completeBlock:(void(^)(QAReplyFavorRequestItem *item,NSError *error))completeBlock;
//发表问题
+ (void)createAskWithTitle:(NSString *)title
                   content:(NSString *)content
                attachmentID:(NSString *)attachmentID
             completeBlock:(void(^)(HttpBaseRequestItem *item,NSError *error))completeBlock;
//回答问题
+ (void)createAnswerWithAskID:(NSString *)askID
                   answer:(NSString *)answer
             completeBlock:(void(^)(HttpBaseRequestItem *item,NSError *error))completeBlock;
@end
