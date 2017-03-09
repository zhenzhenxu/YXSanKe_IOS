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

//用户名密码登录
+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void(^)(NSError *error))completeBlock;
//游客登录
+ (void)touristLoginWithCompleteBlock:(void(^)(NSError *error))completeBlock;
/**
 发送短信验证码
 
 @param mobileNumber 手机号
 @param type 获取验证码的类型(注册：register ;忘记密码：password)
 @param completeBlock 请求的回调
 */
+ (void)sendVerifyCodeWithMobileNumber:(NSString *)mobileNumber
                                  type:(NSString *)type
                         completeBlock:(void(^)(NSError *error))completeBlock;
//验证短信验证码
+ (void)checkVerifyCodeWithMobileNumber:(NSString *)mobileNumber
                             verifyCode:(NSString *)verifyCode
                          completeBlock:(void(^)(NSError *error))completeBlock;
//注册
+ (void)registerWithUserName:(NSString *)userName
                    password:(NSString *)password
                mobileNumber:(NSString *)mobileNumber
               completeBlock:(void(^)(NSError *error))completeBlock;
//忘记密码重置
+ (void)changePasswordWithMobileNumber:(NSString *)mobileNumber
                             password:(NSString *)password
                        completeBlock:(void(^)(NSError *error))completeBlock;


@end
