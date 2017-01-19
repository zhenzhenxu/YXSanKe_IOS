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

@interface UserAreaSelectedInfoItem : NSObject

@property (nonatomic, assign) NSInteger selectedProvinceRow;
@property (nonatomic, assign) NSInteger selectedCityRow;
@property (nonatomic, assign) NSInteger selectedCountyRow;

@end

@interface UserAreaInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) AreaModel *model;
- (void)resetSelectedProvinceDataWithUserModel:(UserModel *)userModel;//设置选中的地区
- (UserAreaSelectedInfoItem *)selectedItem;
- (void)updateAreaWithCompleteBlock:(void(^)(NSError *error))completeBlock;
@end
