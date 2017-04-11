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

typedef void(^UpdateAreaBlock)(NSString *areaID);
@interface UserAreaSelectedInfoItem : NSObject

@property (nonatomic, assign) NSInteger provinceRow;
@property (nonatomic, assign) NSInteger cityRow;
@property (nonatomic, assign) NSInteger districtRow;
@property (nonatomic, strong) Area *province;
@property (nonatomic ,strong)NSArray<Area *> *cityArray;
@property (nonatomic ,strong)NSArray<Area *> *districtArray;
@property (nonatomic, strong) Area *city;
@property (nonatomic, strong) Area *district;
@end

@interface UserAreaInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) AreaModel *model;
@property (nonatomic, strong, readonly) UserAreaSelectedInfoItem *item;

- (void)resetSelectedProvinceDataWithUserModel:(MineUserModel *)userModel;
- (void)setUpdateAreaBlock:(UpdateAreaBlock)block;
- (void)updateArea;
- (UserAreaSelectedInfoItem *)selectedInfoItem;
@end
