//
//  UserInfoPickerView.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmButtonActionBlock)(void);

@interface UserInfoPickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;

- (void)showPickerView;
- (void)hidePickerView;
// 显示PickerView并展示数据
- (void)reloadPickerView;
- (void)setConfirmButtonActionBlock:(ConfirmButtonActionBlock)block;

@end
