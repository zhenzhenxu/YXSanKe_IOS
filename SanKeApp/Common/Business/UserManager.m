//
//  UserManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserManager.h"

NSString * const kUserDidLoginNotification = @"kUserDidLoginNotification";
NSString * const kUserDidLogoutNotification = @"kUserDidLogoutNotification";

@implementation UserManager

+ (UserManager *)sharedInstance {
    static dispatch_once_t once;
    static UserManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[UserManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)setLoginStatus:(BOOL)loginStatus {
    _loginStatus = loginStatus;
    if (loginStatus) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kUserDidLoginNotification object:nil];
    }else {
        [[NSNotificationCenter defaultCenter]postNotificationName:kUserDidLogoutNotification object:nil];
    }
}

@end
