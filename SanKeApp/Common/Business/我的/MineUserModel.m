//
//  MineUserModel.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineUserModel.h"

@implementation MineUserModel

+ (MineUserModel *)mineUserModelFromRawModel:(UserModel *)model {
    
    if (!model) {
        return nil;
    }
    MineUserModel *mineUserModel = [[MineUserModel alloc]init];
    mineUserModel.backgroundImageUrl = model.backgroundImageUrl;
    mineUserModel.name = model.truename;
    mineUserModel.portraitUrl = model.portraitUrl;
    
    WEAK_SELF
    [StageSubjectDataManager fetchStageSubjectWithStageID:model.stageID subjectID:model.subjectID completeBlock:^(FetchStageSubjectRequestItem_stage *stage, FetchStageSubjectRequestItem_subject *subject) {
        STRONG_SELF
        mineUserModel.stage = stage;
        mineUserModel.subject = subject;
    }];
    [AreaDataManager fetchAreaWithProvinceID:model.provinceID cityID:model.cityID districtID:model.districtID completeBlock:^(Area *province, Area *city, Area *district) {
        STRONG_SELF
        mineUserModel.province = province;
        mineUserModel.city = city;
        mineUserModel.district = district;
    }];
    [UserInfoDataManger fetchUserInfoWithRoleID:model.role genderID:model.gender experienceID:model.experience completeBlock:^(UserInfo *role, UserInfo *gender, UserInfo *experience) {
       mineUserModel.role = role;
       mineUserModel.gender = gender;
       mineUserModel.experience = experience;
   }];
    return mineUserModel;
}

@end
