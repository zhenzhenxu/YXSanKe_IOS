//
//  StageSubjectDataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchStageSubjectRequest.h"

@interface StageSubjectDataManager : NSObject
+ (void)updateToLatestData;
+ (FetchStageSubjectRequestItem *)dataForStageAndSubject;

+ (void)fetchStageSubjectWithStageID:(NSString *)stageID subjectID:(NSString *)subjectID completeBlock:(void(^)(FetchStageSubjectRequestItem_stage *stage,FetchStageSubjectRequestItem_subject *subject))completeBlock;
@end
