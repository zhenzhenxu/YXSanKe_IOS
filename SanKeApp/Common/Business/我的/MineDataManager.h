//
//  MineDataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kStageSubjectDidChangeNotification;

@interface MineDataManager : NSObject
+ (void)updateStage:(NSString *)stageID subject:(NSString *)subjectID completeBlock:(void(^)(NSError *error))completeBlock;
+ (void)updateArea:(NSString *)areaID completeBlock:(void(^)(NSError *error))completeBlock;
@end
