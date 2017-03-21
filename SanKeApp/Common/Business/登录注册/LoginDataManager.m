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
#import "SendSMSRequest.h"
#import "CheckSMSRequest.h"
#import "RegisterRequest.h"
#import "ChangePasswordRequest.h"

@interface LoginDataManager()
@property (nonatomic, strong) LoginRequest *loginRequest;
@property (nonatomic, strong) TouristLoginRequest *touristLoginRequest;
@property (nonatomic, strong) SendSMSRequest *sendSMSRequest;
@property (nonatomic, strong) CheckSMSRequest *checkSMSRequest;
@property (nonatomic, strong) RegisterRequest *registerRequest;
@property (nonatomic, strong) ChangePasswordRequest *changePasswordRequest;
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

+ (void)sendVerifyCodeWithMobileNumber:(NSString *)mobileNumber type:(NSString *)type completeBlock:(void (^)(NSError *))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.sendSMSRequest stopRequest];
    manager.sendSMSRequest = [[SendSMSRequest alloc]init];
    manager.sendSMSRequest.mobile = mobileNumber;
    manager.sendSMSRequest.from = type;
    WEAK_SELF
    [manager.sendSMSRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+ (void)checkVerifyCodeWithMobileNumber:(NSString *)mobileNumber verifyCode:(NSString *)verifyCode type:(NSString *)type completeBlock:(void (^)(NSError *))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.checkSMSRequest stopRequest];
    manager.checkSMSRequest = [[CheckSMSRequest alloc]init];
    manager.checkSMSRequest.mobile = mobileNumber;
    manager.checkSMSRequest.code = verifyCode;
    manager.checkSMSRequest.from = type;
    WEAK_SELF
    [manager.checkSMSRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+ (void)registerWithUserName:(NSString *)userName password:(NSString *)password mobileNumber:(NSString *)mobileNumber completeBlock:(void (^)(NSError *))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.registerRequest stopRequest];
    manager.registerRequest = [[RegisterRequest alloc]init];
    manager.registerRequest.username = userName;
    manager.registerRequest.password = [password md5];
    manager.registerRequest.mobile = mobileNumber;
    WEAK_SELF
    [manager.registerRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        HttpBaseRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        [UserManager sharedInstance].userModel = model;
        
        YXProblemItem *problemItem = [[YXProblemItem alloc]init];
        problemItem.type = YXRecordRegisterSuccessfulType;
        [YXRecordManager addRecord:problemItem];
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+ (void)changePasswordWithMobileNumber:(NSString *)mobileNumber password:(NSString *)password completeBlock:(void (^)(NSError *))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.changePasswordRequest stopRequest];
    manager.changePasswordRequest = [[ChangePasswordRequest alloc]init];
    manager.changePasswordRequest.mobile = mobileNumber;
    manager.changePasswordRequest.password = [password md5];
    WEAK_SELF
    [manager.changePasswordRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
}

@end
