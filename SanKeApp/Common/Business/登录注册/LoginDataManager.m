//
//  LoginDataManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginDataManager.h"
#import "LoginRequest.h"
#import "TouristLoginRequest.h"

@interface LoginDataManager()
@property (nonatomic, strong) LoginRequest *loginRequest;
@property (nonatomic, strong) TouristLoginRequest *touristLoginRequest;
@end

@implementation LoginDataManager
+ (LoginDataManager *)sharedInstance {
    static dispatch_once_t once;
    static LoginDataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[LoginDataManager alloc] init];
    });
    
    return sharedInstance;
}

+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void(^)(NSError *error))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.loginRequest stopRequest];
    manager.loginRequest = [[LoginRequest alloc]init];
    manager.loginRequest.username = name;
    manager.loginRequest.password = [password md5];
    WEAK_SELF
    [manager.loginRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        HttpBaseRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        [UserManager sharedInstance].userModel = model;
        if (model.isTaged) {
            [UserManager sharedInstance].loginStatus = YES;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+ (void)touristLoginWithCompleteBlock:(void(^)(NSError *error))completeBlock {
    NSString *uuid = [[NSUUID UUID]UUIDString];
    [self touristLoginWithUUID:uuid completeBlock:completeBlock];
}

+ (void)touristLoginWithUUID:(NSString *)uuid completeBlock:(void(^)(NSError *error))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.touristLoginRequest stopRequest];
    manager.touristLoginRequest = [[TouristLoginRequest alloc]init];
    manager.touristLoginRequest.uuid = uuid;
    WEAK_SELF
    [manager.touristLoginRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        HttpBaseRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        [UserManager sharedInstance].userModel = model;
        if (model.isTaged) {
            [UserManager sharedInstance].loginStatus = YES;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+ (void)getVerifyCodeWithMobileNumber:(NSString *)mobileNumber completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    
}

+ (void)verifySMSCodeWithMobileNumber:(NSString *)mobileNumber verifyCode:(NSString *)verifyCode completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    
}

+ (void)resetPasswordWithMobileNumber:(NSString *)mobileNumber password:(NSString *)password completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    
}
+ (void)registerWithInfo:(id)registerInfo completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    //注册成功之后保存用户信息
    
}
@end
