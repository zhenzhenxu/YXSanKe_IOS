//
//  UserAreaInfoPicker.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AreaDataManager;
@class UserInfoPickerView;
@class MineUserModel;

@interface UserAreaSelectedInfoItem : NSObject

@property (nonatomic, assign) NSInteger selectedProvinceRow;
@property (nonatomic, assign) NSInteger selectedCityRow;
@property (nonatomic, assign) NSInteger selectedCountyRow;
@property (nonatomic, strong) Area *selectedProvince;
@property (nonatomic ,strong)NSArray<Area *> *selectedCitys;
@property (nonatomic ,strong)NSArray<Area *> *selectedCounties;
@property (nonatomic, strong) Area *selectedCity;
@property (nonatomic, strong) Area *selectedCounty;
@end

@interface UserAreaInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) AreaModel *model;
@property (nonatomic, strong, readonly) UserAreaSelectedInfoItem *item;

- (void)resetSelectedProvinceDataWithUserModel:(MineUserModel *)userModel;
- (void)updateAreaWithCompleteBlock:(void(^)(NSError *error))completeBlock;

- (UserAreaSelectedInfoItem *)selectedInfoItem;
@end
