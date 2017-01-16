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
@interface UserAreaInfoItem : NSObject
@property (nonatomic, assign) NSInteger firstInteg;
@end
@interface UserAreaInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) AreaModel *model;
@property (nonatomic, strong) Area *selectedProvince;
@property (nonatomic ,strong)NSArray<Area *> *selectedCitys;
@property (nonatomic ,strong)NSArray<Area *> *selectedCounties;
@property (nonatomic, assign) NSInteger integer;
- (void)selectRow:(UIPickerView *)view ;
@end
