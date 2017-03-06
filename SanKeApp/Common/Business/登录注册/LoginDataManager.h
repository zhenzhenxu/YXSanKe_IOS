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

//设置/重置密码
+ (void)setPasswordWithMobileNumber:(NSString *)mobileNumber
                             password:(NSString *)password
                        completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
////注册
//+ (void)registerWithModel:(RegisterModel *)registerModel completeBlock:(void(^)(YXRegisterRequestItem *item, NSError *error))completeBlock;
////第三方注册
//+ (void)thirdRegisterWithModel:(ThirdRegisterModel *)thirdRegisterModel completeBlock:(void(^)(YXThirdRegisterRequestItem *item, NSError *error))completeBlock;
////发送验证码
+ (void)getVerifyCodeWithMobileNumber:(NSString *)mobileNumber completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
//验证短信验证码
+ (void)verifySMSCodeWithMobileNumber:(NSString *)mobileNumber
                           verifyCode:(NSString *)verifyCode
                        completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;

@end
