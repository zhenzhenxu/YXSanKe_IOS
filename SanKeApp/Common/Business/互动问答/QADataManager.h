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

extern NSString * const kQAQuestionInfoUpdateNotification; // 问题信息更新通知
extern NSString * const kQAReplyInfoUpdateNotification; // 回复信息更新通知

// 问题信息通知的key
extern NSString * const kQAQuestionIDKey;
extern NSString * const kQAQuestionReplyCountKey;
extern NSString * const kQAQuestionBrowseCountKey;

// 回复信息通知的key
extern NSString * const kQAReplyIDKey;
extern NSString * const kQAReplyFavorCountKey;

@interface QADataManager : NSObject
+ (void)requestQuestionDetailWithID:(NSString *)questionID completeBlock:(void(^)(QAQuestionDetailRequestItem *item,NSError *error))completeBlock;
+ (void)requestReplyFavorWithID:(NSString *)answerID completeBlock:(void(^)(QAReplyFavorRequestItem *item,NSError *error))completeBlock;
@end
