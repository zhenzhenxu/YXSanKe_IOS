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

@interface QADataManager : NSObject
+ (void)requestQuestionDetailWithID:(NSString *)questionID completeBlock:(void(^)(QAQuestionDetailRequestItem *item,NSError *error))completeBlock;
+ (void)requestReplyFavorWithID:(NSString *)answerID completeBlock:(void(^)(QAReplyFavorRequestItem *item,NSError *error))completeBlock;
@end
