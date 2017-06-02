//
//  QADataManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QADataManager.h"
#import "NSString+YXString.h"
#import "UIImage+YXImage.h"

NSString * const kQAQuestionInfoUpdateNotification = @"kQAQuestionInfoUpdateNotification";
NSString * const kQAReplyInfoUpdateNotification = @"kQAReplyInfoUpdateNotification";
NSString * const kQACreateQuestionSuccessNotification = @"kQACreateQuestionSuccessNotification";
NSString * const kQACreateReplySuccessNotification = @"kQACreateReplySuccessNotification";

NSString * const kQAQuestionIDKey = @"kQAQuestionIDKey";
NSString * const kQAQuestionReplyCountKey = @"kQAQuestionReplyCountKey";
NSString * const kQAQuestionBrowseCountKey = @"kQAQuestionBrowseCountKey";
NSString * const kQAQuestionUpdateTimeKey = @"kQAQuestionUpdateTimeKey";

NSString * const kQAReplyIDKey = @"kQAReplyIDKey";
NSString * const kQAReplyFavorCountKey = @"kQAReplyFavorCountKey";
NSString * const kQAReplyUserFavorKey = @"kQAReplyUserFavorKey";

@interface QADataManager()
@property (nonatomic, strong) QAQuestionDetailRequest *questionDetailRequest;
@property (nonatomic, strong) QAReplyFavorRequest *replyFavorRequest;
@property (nonatomic, strong) QACreateAskRequest *createAskRequest;
@property (nonatomic, strong) QACreateAnswerRequest *createAnswerRequest;
@property (nonatomic, strong) QAFileUploadFirstStepRequest *fileUploadFirstStepRequest;
@property (nonatomic, strong) QAFileUploadSecondStepRequest *fileUploadSecondStepRequest;
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
        [[NSNotificationCenter defaultCenter]postNotificationName:kQAReplyInfoUpdateNotification object:nil userInfo:@{kQAReplyIDKey:answerID,kQAReplyFavorCountKey:item.data.likeNum,kQAReplyUserFavorKey:item.data.isLike}];
    }];
}

+ (void)createAskWithTitle:(NSString *)title content:(NSString *)content attachmentID:(NSString *)attachmentID completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    QADataManager *manager = [QADataManager sharedInstance];
    [manager.createAskRequest stopRequest];
    manager.createAskRequest = [[QACreateAskRequest alloc]init];
    manager.createAskRequest.title = title;
    manager.createAskRequest.content = content;
    manager.createAskRequest.attachment = attachmentID;
    WEAK_SELF
    [manager.createAskRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error)
            return;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kQACreateQuestionSuccessNotification object:nil];
        BLOCK_EXEC(completeBlock,retItem,nil)
    }];
}

+ (void)createAnswerWithAskID:(NSString *)askID answer:(NSString *)answer completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    QADataManager *manager = [QADataManager sharedInstance];
    [manager.createAnswerRequest stopRequest];
    manager.createAnswerRequest = [[QACreateAnswerRequest alloc]init];
    manager.createAnswerRequest.ask_id = askID;
    manager.createAnswerRequest.answer = answer;
    WEAK_SELF
    [manager.createAnswerRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:kQACreateReplySuccessNotification object:nil];
    }];
    
}

+ (void)uploadFile:(UIImage *)image fileName:(NSString *)fileName completeBlock:(void (^)(QAFileUploadSecondStepRequestItem *, NSError *))completeBlock {
    QADataManager *manager = [QADataManager sharedInstance];
    [manager.fileUploadFirstStepRequest stopRequest];
    manager.fileUploadFirstStepRequest = [[QAFileUploadFirstStepRequest alloc]init];
    
    NSData* data = UIImageJPEGRepresentation(image, 1.0);
    NSString *sizeStr = [NSString stringWithFormat:@"%@", @(data.length)];
//    manager.fileUploadFirstStepRequest.chunks = @"1";
    manager.fileUploadFirstStepRequest.size = sizeStr;
    manager.fileUploadFirstStepRequest.chunkSize = sizeStr;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString*dateStr = [NSString stringWithFormat:@"%0.f", time];
    NSString *userId = [UserManager sharedInstance].userModel.oldUserId;//@"23246746";
    NSString *infoStr = [NSString stringWithFormat:@"%@%@%@",userId,dateStr,sizeStr];
    NSString *md5 = [infoStr yx_md5];
    manager.fileUploadFirstStepRequest.md5 = md5;
    manager.fileUploadFirstStepRequest.name = fileName;
    manager.fileUploadFirstStepRequest.file = data;
    manager.fileUploadFirstStepRequest.userId = userId;
    manager.fileUploadFirstStepRequest.lastModifiedDate = dateStr;
    WEAK_SELF
    [manager.fileUploadFirstStepRequest startRequestWithRetClass:[NSObject class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        [manager.fileUploadSecondStepRequest stopRequest];
        manager.fileUploadSecondStepRequest = [[QAFileUploadSecondStepRequest alloc]init];
        manager.fileUploadSecondStepRequest.filename = fileName;
        manager.fileUploadSecondStepRequest.md5 = md5;
        [manager.fileUploadSecondStepRequest startRequestWithRetClass:[QAFileUploadSecondStepRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            if (error) {
                BLOCK_EXEC(completeBlock,nil,error);
                return;
            }
            BLOCK_EXEC(completeBlock,retItem,nil);
        }];
    }];
}

@end
