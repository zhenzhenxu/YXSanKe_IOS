//
//  MineDataManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineDataManager.h"
#import "UpdateStageSubjectRequest.h"
#import "UpdateAreaRequest.h"
#import "UploadHeadImgRequest.h"
#import "UpdateInfoRequest.h"
#import "UIImage+YXImage.h"
#import "UpdateUserNameRequest.h"

NSString * const kStageSubjectDidChangeNotification = @"kStageSubjectDidChangeNotification";
NSString *const kUpdateHeadPortraitSuccessNotification = @"kUpdateHeadPortraitSuccessNotification";
NSString *const kUpdateUserNameSuccessNotification = @"kUpdateUserNameSuccessNotification";

@interface MineDataManager()
@property (nonatomic, strong) UpdateStageSubjectRequest *stageSubjectRequest;
@property (nonatomic, strong) UpdateAreaRequest *areaRequest;
@property (nonatomic, strong) UploadHeadImgRequest *uploadHeadImgRequest;
@property (nonatomic, strong) UpdateInfoRequest *updateInfoRequest;
@property (nonatomic, strong) UpdateUserNameRequest *updateUserNameRequest;

@end

@implementation MineDataManager
+ (MineDataManager *)sharedInstance {
    static dispatch_once_t once;
    static MineDataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[MineDataManager alloc] init];
    });
    
    return sharedInstance;
}

+ (void)updateStage:(NSString *)stageID subject:(NSString *)subjectID completeBlock:(void(^)(NSError *error))completeBlock {
    MineDataManager *manager = [MineDataManager sharedInstance];
    [manager.stageSubjectRequest stopRequest];
    manager.stageSubjectRequest = [[UpdateStageSubjectRequest alloc]init];
    manager.stageSubjectRequest.stage = stageID;
    manager.stageSubjectRequest.subject = subjectID;
    WEAK_SELF
    [manager.stageSubjectRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        HttpBaseRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        UserModel *oldModel = [UserManager sharedInstance].userModel;
        [UserManager sharedInstance].userModel = model;
        if (!oldModel.isTaged && model.isTaged) {
            [UserManager sharedInstance].loginStatus = YES;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kStageSubjectDidChangeNotification object:nil];
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+ (void)updateArea:(NSString *)areaID completeBlock:(void(^)(NSError *error))completeBlock {
    MineDataManager *manager = [MineDataManager sharedInstance];
    [manager.areaRequest stopRequest];
    manager.areaRequest = [[UpdateAreaRequest alloc]init];
    manager.areaRequest.area = areaID;
    WEAK_SELF
    [manager.areaRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        HttpBaseRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        [UserManager sharedInstance].userModel = model;
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+ (void)updateHeadPortrait:(UIImage *)portrait completeBlock:(void (^)(NSError *))completeBlock {
    MineDataManager *manager = [MineDataManager sharedInstance];
    [manager.uploadHeadImgRequest stopRequest];
    manager.uploadHeadImgRequest = [[UploadHeadImgRequest alloc] init];
    NSData *data = [UIImage compressionImage:portrait limitSize:2*1024*1024];
    [manager.uploadHeadImgRequest.request setData:data
                                     withFileName:@"head.jpg"
                                   andContentType:nil
                                           forKey:@"newUpload"];
    WEAK_SELF
    [manager.uploadHeadImgRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        HttpBaseRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        [UserManager sharedInstance].userModel = model;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateHeadPortraitSuccessNotification
                                                            object:nil];
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+(void)updateSupplementUserInfo:(SupplementUserInfo *)supplementUserInfo completeBlock:(void (^)(NSError *))completeBlock {
    MineDataManager *manager = [MineDataManager sharedInstance];
    [manager.updateInfoRequest stopRequest];
    manager.updateInfoRequest = [[UpdateInfoRequest alloc]init];
    manager.updateInfoRequest.stage = supplementUserInfo.stageID;
    manager.updateInfoRequest.subject = supplementUserInfo.subjectID;
    manager.updateInfoRequest.area = supplementUserInfo.areaID;
    manager.updateInfoRequest.role = supplementUserInfo.roleID;
    manager.updateInfoRequest.sex = supplementUserInfo.genderID;
    manager.updateInfoRequest.experience = supplementUserInfo.experienceID;
    WEAK_SELF
    [manager.updateInfoRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        HttpBaseRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        UserModel *oldModel = [UserManager sharedInstance].userModel;
        [UserManager sharedInstance].userModel = model;
        if (!oldModel.isTaged && model.isTaged) {
            [UserManager sharedInstance].loginStatus = YES;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
}

+ (void)updateUserName:(NSString *)userName completeBlock:(void (^)(NSError *))completeBlock {
    MineDataManager *manager = [MineDataManager sharedInstance];
    [manager.updateUserNameRequest stopRequest];
    manager.updateUserNameRequest = [[UpdateUserNameRequest alloc]init];
    manager.updateUserNameRequest.username = userName;
    WEAK_SELF
    [manager.updateUserNameRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        HttpBaseRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        [UserManager sharedInstance].userModel = model;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserNameSuccessNotification
                                                            object:nil];
        BLOCK_EXEC(completeBlock,nil);
    }];
    
}
@end
