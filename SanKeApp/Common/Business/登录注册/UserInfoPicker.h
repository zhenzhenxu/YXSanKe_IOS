//
//  UserInfoPicker.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;

@interface UserInfoItem : NSObject

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, assign) NSInteger row;

@end


@interface UserInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSArray<UserInfo *> *dataArray;
@property (nonatomic, strong, readonly) UserInfoItem *selectedItem;

- (void)resetSelectedInfo:(UserInfo *)userInfo;

@end
