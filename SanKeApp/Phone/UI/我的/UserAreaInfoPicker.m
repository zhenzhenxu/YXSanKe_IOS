//
//  UserAreaInfoPicker.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserAreaInfoPicker.h"
#import "AreaDataManager.h"

@implementation UserAreaSelectedInfoItem
@end

@interface UserAreaInfoPicker ()
@property (nonatomic, strong) Area *selectedProvince;
@property (nonatomic ,strong)NSArray<Area *> *selectedCitys;
@property (nonatomic ,strong)NSArray<Area *> *selectedCounties;
@property (nonatomic, strong) Area *selectedCity;
@property (nonatomic, strong) Area *selectedCounty;
@end

@implementation UserAreaInfoPicker

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.model.areas.count;
        case 1:
            return self.selectedCitys.count;
        case 2:
            return self.selectedCounties.count;
        default:
            return 0;
    }
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
    switch (component) {
        case 0:
        {
            Area *area = self.model.areas[row];
            return area.name;
        }
        case 1:
        {
            return self.selectedCitys[row].name;
            
        }
        case 2:
        {
            
            return self.selectedCounties[row].name;
        }
        default:
            return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel* selectLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    selectLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    switch (component) {
        case 0:
        {
            Area *area = self.model.areas[row];
            self.selectedCitys = area.subAreas;
            if (self.selectedCitys.count > 0){
                self.selectedCounties = self.selectedCitys[0].subAreas;
            }else{
                self.selectedCounties = nil;
            }
            
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:NO];
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
        case 1:
        {
            if (self.selectedCitys.count > row){
                Area *area = self.selectedCitys[row];
                self.selectedCounties = area.subAreas;
            }else{
                self.selectedCounties = nil;
            }
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
        case 2:
        default:
            break;
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

- (void)resetSelectedProvinceDataWithUserModel:(UserModel *)userModel {
//    if (!profile) {
//        return;
//    }
//    [self getProvinceList];//获取地区的数据 现在用UpgradeManager就行
    [self.model.areas enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.provinceID isEqualToString:subArea.number]) {
            self.selectedProvince = subArea;
            self.selectedCitys = self.selectedProvince.subAreas;
            *stop = YES;
        }
    }];
    [self.selectedCitys enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.cityID isEqualToString:subArea.number]) {
            self.selectedCity = subArea;
            self.selectedCounties = self.selectedCity.subAreas;
            *stop = YES;
        }
    }];
    [self.selectedCounties enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.districtID isEqualToString:subArea.number]) {
            self.selectedCounty = subArea;
            *stop = YES;
        }
    }];
}

- (UserAreaSelectedInfoItem *)selectedItem {
    UserAreaSelectedInfoItem *item = [[UserAreaSelectedInfoItem alloc]init];
    item.selectedProvinceRow = 0;
    item.selectedCityRow = 0;
    item.selectedCountyRow = 0;
    if ([self.model.areas containsObject:self.selectedProvince]) {
        item.selectedProvinceRow = [self.model.areas indexOfObject:self.selectedProvince];
    } else if (self.model.areas > 0) {
        self.selectedCitys = ((Area *)self.model.areas[0]).subAreas;
    }
    
    if ([self.selectedCitys containsObject:self.selectedCity]) {
        item.selectedCityRow = [self.selectedCitys indexOfObject:self.selectedCity];
    } else if (self.selectedCitys.count > 0) {
        self.selectedCounties = ((Area *)self.selectedCitys[0]).subAreas;
    }
    
    if ([self.selectedCounties containsObject:self.selectedCounty]) {
        item.selectedCountyRow = [self.selectedCounties indexOfObject:self.selectedCounty];
    }
    return item;
}
@end
