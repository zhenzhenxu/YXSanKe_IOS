//
//  LoginUtils.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUtils : NSObject
//验证手机号
+ (void)verifyMobileNumberFormat:(NSString *)mobileNumber completeBlock:(void(^)(BOOL isEmpty, BOOL formatIsCorrect))completeBlock;
//验证密码
+ (void)verifyPasswordFormat:(NSString *)password completeBlock:(void(^)(BOOL isEmpty, BOOL formatIsCorrect))completeBlock;
//验证验证码
+ (void)verifySMSCodeFormat:(NSString *)SMSCode completeBlock:(void(^)(BOOL isEmpty, BOOL formatIsCorrect))completeBlock;


@end
