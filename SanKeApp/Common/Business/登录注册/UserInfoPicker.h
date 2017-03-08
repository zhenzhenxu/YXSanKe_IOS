//
//  UserInfoPicker.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;


@interface UserInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSArray<UserInfo *> *dataArray;

- (void)resetSelectedInfo:(UserInfo *)userInfo;

- (NSInteger)selectedInfoRow;
@end
