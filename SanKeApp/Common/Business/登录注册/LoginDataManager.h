//
//  LoginDataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginDataManager : NSObject
+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void(^)(NSError *error))completeBlock;
+ (void)touristLoginWithCompleteBlock:(void(^)(NSError *error))completeBlock;
@end
