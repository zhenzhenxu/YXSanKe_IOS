//
//  UserInfoPicker.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoPicker.h"
#import "UserInfoDataManger.h"
#import "MineUserModel.h"

@implementation UserInfoItem
@end

@interface UserInfoPicker ()

@property (nonatomic, strong) UserInfoItem *selectedItem;

@end

@implementation UserInfoPicker
#pragma mark - UIPickerViewDataSource

- (instancetype)init{
    if (self = [super init]) {
        self.selectedItem = [[UserInfoItem alloc]init];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSInteger count = [self numberOfComponentsInPickerView:pickerView];
    if (count <= 0) {
        return 0;
    }
    
    return (CGRectGetWidth([UIScreen mainScreen].bounds)) / count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 36.f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UserInfo *info = self.dataArray[row];
    return info.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel* selectLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    selectLabel.textColor = [UIColor colorWithHexString:@"1d878b"];
    if (self.dataArray.count > row) {
        self.selectedItem.userInfo = self.dataArray[row];
        self.selectedItem.row = row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/3.0f - 15.0f, 30)];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
        pickerLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)resetSelectedInfo:(UserInfo *)userInfo {
    [self.dataArray enumerateObjectsUsingBlock:^(UserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([userInfo.infoID isEqualToString:obj.infoID]) {
            self.selectedItem.userInfo = obj;
            *stop = YES;
        }
    }];
    if(!self.selectedItem.userInfo) {
        self.selectedItem.userInfo = self.dataArray.firstObject;
        return;
    }
}

@end
