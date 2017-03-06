//
//  SetPasswordViewController.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginBaseViewController.h"

// 密码操作类型
typedef NS_ENUM(NSInteger, PasswordOperationType) {
    PasswordOperationType_FirstSet = 1,
    PasswordOperationType_Reset 
};

@interface SetPasswordViewController : LoginBaseViewController

- (instancetype)initWithType:(PasswordOperationType)type phoneNumber:(NSString *)phoneNumber;

@end
