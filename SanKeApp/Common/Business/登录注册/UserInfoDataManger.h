//
//  UserInfoDataManger.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserInfo
@end
@interface UserInfo:JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *infoID;
@end

@interface UserInfoModel:JSONModel
@property (nonatomic ,strong)NSArray<UserInfo,Optional> *role;//身份
@property (nonatomic ,strong)NSArray<UserInfo,Optional> *gender;//性别
@property (nonatomic ,strong)NSArray<UserInfo,Optional> *experience;//工作年限

@end


@interface UserInfoData:JSONModel
@property (nonatomic, strong) UserInfoModel<Optional> *data;
@property (nonatomic, copy) NSString<Optional> *version;
@end


@interface UserInfoDataManger : NSObject

+ (UserInfoData *)userInfoData;

+ (void)fetchUserInfoWithRoleID:(NSString *)roleID genderID:(NSString *)genderID experienceID:(NSString *)experienceID completeBlock:(void(^)(UserInfo *role,UserInfo *gender,UserInfo *experience))completeBlock;
@end
