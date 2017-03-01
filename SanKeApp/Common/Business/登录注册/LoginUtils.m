//
//  LoginUtils.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginUtils.h"

@implementation LoginUtils
+ (void)verifyMobileNumberFormat:(NSString *)mobileNumber completeBlock:(void (^)(BOOL, BOOL))completeBlock {
    BOOL isEmpty = NO;
    BOOL formatIsCorrect = YES;
    if (![mobileNumber yx_isValidString]) {
        isEmpty = YES;
    }
    if (![mobileNumber yx_isPhoneNum]) {
        formatIsCorrect = NO;
    }
    BLOCK_EXEC(completeBlock,isEmpty,formatIsCorrect);
}

+ (void)verifyPasswordFormat:(NSString *)password completeBlock:(void (^)(BOOL, BOOL))completeBlock {
    BOOL isEmpty = NO;
    BOOL formatIsCorrect = YES;
    if (![password yx_isValidString]) {
        isEmpty = YES;
    }
    if (password.length < 6 || password.length > 18) {
        formatIsCorrect = NO;
    }
    BLOCK_EXEC(completeBlock,isEmpty,formatIsCorrect);
}

+ (void)verifySMSCodeFormat:(NSString *)SMSCode completeBlock:(void (^)(BOOL, BOOL))completeBlock {
    BOOL isEmpty = NO;
    BOOL formatIsCorrect = NO;
    if (![SMSCode yx_isValidString]) {
        isEmpty = YES;
    }
    if (SMSCode.length == 4) {
        formatIsCorrect = YES;
    }
    BLOCK_EXEC(completeBlock,isEmpty,formatIsCorrect);
}

@end
