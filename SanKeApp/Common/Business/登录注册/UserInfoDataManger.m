//
//  UserInfoDataManger.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoDataManger.h"

@implementation UserInfo
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"infoID"}];
}
@end

@implementation UserInfoModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"身份":@"role",
                                                       @"性别":@"gender",
                                                       @"入职年份":@"experience"
                                                       }];
}
@end

@implementation UserInfoData
@end

@implementation UserInfoDataManger

+ (UserInfoData *)userInfoData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"userInfo" ofType:@"json"];;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    UserInfoData *infoData = [[UserInfoData alloc] initWithData:data error:&error];
    return infoData;
}

+ (void)fetchUserInfoWithRoleID:(NSString *)roleID genderID:(NSString *)genderID experienceID:(NSString *)experienceID completeBlock:(void (^)(UserInfo *, UserInfo *, UserInfo *))completeBlock{
    
    __block UserInfo *role = nil;
    __block UserInfo *gender = nil;
    __block UserInfo *experience = nil;
    
    UserInfoModel *model = [self userInfoData].data;
    [model.role enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.infoID isEqualToString:roleID]) {
            role = obj;
            *stop = YES;
        }
    }];
     [model.gender enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.infoID isEqualToString:genderID]) {
            gender = obj;
            *stop = YES;
        }
     }];
    [model.experience enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.infoID isEqualToString:experienceID]) {
            experience = obj;
            *stop = YES;
        }
    }];
    BLOCK_EXEC(completeBlock,role,gender,experience);
}

@end
