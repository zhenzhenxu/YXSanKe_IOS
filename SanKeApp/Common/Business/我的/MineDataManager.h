//
//  MineDataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplementUserInfo.h"

extern NSString * const kStageSubjectDidChangeNotification;
extern NSString * const kUpdateHeadPortraitSuccessNotification;

@interface MineDataManager : NSObject
//设置学科学段
+ (void)updateStage:(NSString *)stageID subject:(NSString *)subjectID completeBlock:(void(^)(NSError *error))completeBlock;
//设置地区
+ (void)updateArea:(NSString *)areaID completeBlock:(void(^)(NSError *error))completeBlock;
//修改头像
+ (void)updateHeadPortrait:(UIImage *)portrait completeBlock:(void(^)(NSError *error))completeBlock;
//设置用户信息(角色,性别,入职年份)
+ (void)updateSupplementUserInfo:(SupplementUserInfo *)supplementUserInfo completeBlock:(void(^)(NSError *error))completeBlock;
@end
