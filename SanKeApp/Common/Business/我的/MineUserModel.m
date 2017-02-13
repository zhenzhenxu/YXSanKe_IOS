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
    mineUserModel.name = model.name;
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
//    if (isEmpty(model)) {
//       mineUserModel = [mineUserModel setupMock];
//    }
    return mineUserModel;
}

//- (MineUserModel *)setupMock {
//    MineUserModel *mineUserModel = [[MineUserModel alloc]init];
//    mineUserModel.backgroundImageUrl = @"http://s1.jsyxw.cn/zgjiaoyan_static/img/default/background.jpg";
//    mineUserModel.name = @"这是个测试名字";
//    mineUserModel.portraitUrl = @"http://s1.jsyxw.cn/zgjiaoyan_static/img/default/icon.jpg";
//    FetchStageSubjectRequestItem_stage *stage = [[FetchStageSubjectRequestItem_stage alloc]init];
//    stage.name = @"初中";
//    stage.stageID = @"1001";
//    FetchStageSubjectRequestItem_subject *subject = [[FetchStageSubjectRequestItem_subject alloc]init];
//    subject.name = @"七年级上册";
//    subject.subjectID = @"2001";
//    FetchStageSubjectRequestItem_subject *subject1 = [[FetchStageSubjectRequestItem_subject alloc]init];
//    subject1.name = @"七年级上册1";
//    subject.subjectID = @"2002";
//    FetchStageSubjectRequestItem_subject *subject2 = [[FetchStageSubjectRequestItem_subject alloc]init];
//    subject2.name = @"七年级上册2";
//    subject2.subjectID = @"2003";
//    FetchStageSubjectRequestItem_subject *subject3 = [[FetchStageSubjectRequestItem_subject alloc]init];
//    subject3.name = @"七年级上册3";
//    subject3.subjectID = @"2004";
//    NSMutableArray *subjects = [NSMutableArray array];
//    [subjects addObject:subject];
//    [subjects addObject:subject1];
//    [subjects addObject:subject2];
//    [subjects addObject:subject3];
//    stage.subjects = subjects.copy;
//    mineUserModel.stage = stage;
//    mineUserModel.subject = subject;
//    Area *province = [[Area alloc]init];
//    province.name = @"山西省";
//    province.areaID = @"140000";
//    mineUserModel.province = province;
//    Area *city = [[Area alloc]init];
//    city.name = @"临汾市";
//    city.areaID = @"141000";
//    mineUserModel.city = city;
//    Area *district = [[Area alloc]init];
//    district.name = @"尧都区";
//    district.areaID = @"141002";
//    mineUserModel.district = district;
//    return mineUserModel;
//}
@end
