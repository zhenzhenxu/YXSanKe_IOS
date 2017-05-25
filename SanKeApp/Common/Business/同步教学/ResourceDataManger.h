//
//  ResourceDataManger.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDetailRequest.h"

extern NSString * const kCreateResourceAskSuccessNotification; // 发布评论成功的通知

@interface ResourceDataManger : NSObject

// 获取资源详情
+ (void)requestResourceDetailWithID:(NSString *)resourceID completeBlock:(void (^)(ResourceDetailRequestItem *item, NSError *error))completeBlock;

// 发送资源评论
+ (void)createResourceAskWithResourceID:(NSString *)resourceID
                       content:(NSString *)content
                             resName:(NSString *)resName
                               resAuthorId:(NSString *)resAuthorId
                completeBlock:(void(^)(HttpBaseRequestItem *item,NSError *error))completeBlock;

@end
