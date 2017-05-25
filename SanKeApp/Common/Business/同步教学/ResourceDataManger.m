//
//  ResourceDataManger.m
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceDataManger.h"
#import "CreateResourceAskRequest.h"

NSString * const kCreateResourceAskSuccessNotification = @"kCreateResourceAskSuccessNotification";

@interface ResourceDataManger ()

@property (nonatomic, strong) ResourceDetailRequest *resourceDetailRequest;
@property (nonatomic, strong) CreateResourceAskRequest *createResourceAskRequest;

@end

@implementation ResourceDataManger

+ (ResourceDataManger *)sharedInstance {
    static ResourceDataManger *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ResourceDataManger alloc] init];
    });
    return sharedInstance;
}

+ (void)requestResourceDetailWithID:(NSString *)resourceID completeBlock:(void (^)(ResourceDetailRequestItem *, NSError *))completeBlock {
    ResourceDataManger *manager = [ResourceDataManger sharedInstance];
    [manager.resourceDetailRequest stopRequest];
    manager.resourceDetailRequest = [[ResourceDetailRequest alloc]init];
    manager.resourceDetailRequest.resourceID = resourceID;
    WEAK_SELF
    [manager.resourceDetailRequest startRequestWithRetClass:[ResourceDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error)
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil)
    }];
}

+ (void)createResourceAskWithResourceID:(NSString *)resourceID content:(NSString *)content resName:(NSString *)resName resAuthorId:(NSString *)resAuthorId completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    ResourceDataManger *manager = [ResourceDataManger sharedInstance];
    [manager.createResourceAskRequest stopRequest];
    manager.createResourceAskRequest = [[CreateResourceAskRequest alloc] init];
    manager.createResourceAskRequest.objectid = resourceID;
    manager.createResourceAskRequest.content = content;
    manager.createResourceAskRequest.objectName = resName;
    manager.createResourceAskRequest.touserId = resAuthorId;
    WEAK_SELF
    [manager.createResourceAskRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:kCreateResourceAskSuccessNotification object:nil];
    }];
}

@end
