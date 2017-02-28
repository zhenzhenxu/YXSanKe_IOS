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
NSString * const kStageSubjectDidChangeNotification = @"kStageSubjectDidChangeNotification";

@interface MineDataManager()
@property (nonatomic, strong) UpdateStageSubjectRequest *stageSubjectRequest;
@property (nonatomic, strong) UpdateAreaRequest *areaRequest;
@property (nonatomic, strong) UploadHeadImgRequest *uploadHeadImgRequest;
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
    WEAK_SELF
    [manager.uploadHeadImgRequest startRequestWithRetClass:[UploadHeadImgRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:YXUploadUserPicSuccessNotification
                                                            object:nil];
        UploadHeadImgRequestItem *item = retItem;
        UserModel *model = [UserModel modelFromRawData:item.info];
        [UserManager sharedInstance].userModel = model;
    }];
    
}
@end
