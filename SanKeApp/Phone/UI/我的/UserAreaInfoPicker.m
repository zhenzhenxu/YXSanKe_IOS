//
//  UserAreaInfoPicker.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserAreaInfoPicker.h"
#import "AreaDataManager.h"
#import "MineUserModel.h"

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
            self.selectedProvince = area;
            self.selectedCitys = area.subAreas;
            self.selectedCity = self.selectedCitys[0];
            if (self.selectedCitys.count > 0){
                self.selectedCounties = self.selectedCitys[0].subAreas;
                self.selectedCounty = self.selectedCounties[0];
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
                self.selectedCity = area;
                self.selectedCounties = area.subAreas;
                self.selectedCounty = self.selectedCounties[0];
            }else{
                self.selectedCounties = nil;
            }
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
        case 2:
        {
            if (self.selectedCounties.count > row){
                Area *area = self.selectedCounties[row];
                self.selectedCounty = area;
            }else {
                self.selectedCounty = nil;
            }
        }
            break;
        default:
            break;
    }
    DDLogDebug(@"要选择地区:%@-%@-%@",self.selectedProvince.name,self.selectedCity.name,self.selectedCounty.name);
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

- (UserAreaSelectedInfoItem *)resetSelectedProvinceDataWithUserModel:(MineUserModel *)userModel {
     UserAreaSelectedInfoItem *item = [[UserAreaSelectedInfoItem alloc]init];
    [self.model.areas enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.province.areaID isEqualToString:subArea.areaID]) {
            self.selectedProvince = subArea;
            self.selectedCitys = self.selectedProvince.subAreas;
            item.selectedProvinceRow = idx;
            *stop = YES;
        }
    }];
    [self.selectedCitys enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.city.areaID isEqualToString:subArea.areaID]) {
            self.selectedCity = subArea;
            self.selectedCounties = self.selectedCity.subAreas;
            item.selectedCityRow = idx;
            *stop = YES;
        }
    }];
    [self.selectedCounties enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.district.areaID isEqualToString:subArea.areaID]) {
            self.selectedCounty = subArea;
            item.selectedCountyRow = idx;
            *stop = YES;
        }
    }];
    DDLogDebug(@"设置选中为%@省-%@市-%@区",self.selectedProvince.name,self.selectedCity.name,self.selectedCounty.name);
     return item;
}

- (void)updateAreaWithCompleteBlock:(void (^)(NSError *))completeBlock {
    DDLogDebug(@"要选择地区:%@-%@-%@",self.selectedProvince.name,self.selectedCity.name,self.selectedCounty.name);
    NSString *area = [NSString stringWithFormat:@"%@,%@,%@",self.selectedProvince.areaID,self.selectedCity.areaID,self.selectedCounty.areaID];
    [MineDataManager updateArea:area completeBlock:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
}
@end
