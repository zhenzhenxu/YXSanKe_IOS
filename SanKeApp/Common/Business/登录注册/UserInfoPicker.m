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

@interface UserInfoPicker ()
@property (nonatomic, strong) UserInfo *selectedInfo;
@end

@implementation UserInfoPicker
#pragma mark - UIPickerViewDataSource
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
        self.selectedInfo = self.dataArray[row];
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
            self.selectedInfo = obj;
            *stop = YES;
        }
    }];
    if(!self.selectedInfo) {
        self.selectedInfo = self.dataArray.firstObject;
        return;
    }
}


- (NSInteger)selectedInfoRow {
    NSInteger selectedRow = 0;
    if (self.dataArray.count > 0) {
        if ([self.dataArray containsObject:self.selectedInfo]) {
            selectedRow = [self.dataArray indexOfObject:self.selectedInfo];
        }
    }
    return selectedRow;
}

@end
