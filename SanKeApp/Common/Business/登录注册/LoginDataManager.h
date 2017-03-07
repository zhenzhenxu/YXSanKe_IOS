//
//  LoginDataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RegisterInfo;
@interface LoginDataManager : NSObject
//登录
+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void(^)(NSError *error))completeBlock;
//游客登录
+ (void)touristLoginWithCompleteBlock:(void(^)(NSError *error))completeBlock;
//发送验证码
+ (void)getVerifyCodeWithMobileNumber:(NSString *)mobileNumber completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
//验证短信验证码
+ (void)verifySMSCodeWithMobileNumber:(NSString *)mobileNumber
                           verifyCode:(NSString *)verifyCode
                        completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
//注册
//+ (void)registerWithInfo:(RegisterInfo *)registerInfo completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
//重置密码
+ (void)resetPasswordWithMobileNumber:(NSString *)mobileNumber
                             password:(NSString *)password
                        completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;


@end
