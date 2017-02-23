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
    selectLabel.textColor = [UIColor colorWithHexString:@"1d878b"];
    switch (component) {
        case 0:
        {
            if (self.model.areas.count > row) {
                self.selectedProvince = self.model.areas[row];
                if (self.selectedProvince.subAreas.count > 0) {
                    self.selectedCitys = self.selectedProvince.subAreas;
                    self.selectedCity = self.selectedCitys[0];
                    if (self.selectedCity.subAreas.count > 0) {
                        self.selectedCounties = self.selectedCity.subAreas;
                        self.selectedCounty = self.selectedCounties[0];
                    }else {
                        self.selectedCounties = nil;
                        self.selectedCounty = nil;
                    }
                }else {
                    self.selectedCitys = nil;
                    self.selectedCity = nil;
                    self.selectedCounties = nil;
                    self.selectedCounty = nil;
                }
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
                self.selectedCity = self.selectedCitys[row];
                if (self.selectedCity.subAreas.count > 0) {
                    self.selectedCounties = self.selectedCity.subAreas;
                    self.selectedCounty = self.selectedCounties[0];
                }else{
                    self.selectedCounties = nil;
                    self.selectedCounty = nil;
                }
            }
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
        case 2:
        {
            if (self.selectedCounties.count > row){
                self.selectedCounty = self.selectedCounties[row];
            }else {
                self.selectedCounty = nil;
            }
        }
            break;
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

- (void)resetSelectedProvinceDataWithUserModel:(MineUserModel *)userModel {
    [self.model.areas enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.province.areaID isEqualToString:subArea.areaID]) {
            self.selectedProvince = subArea;
            self.selectedCitys = self.selectedProvince.subAreas;
            *stop = YES;
        }
    }];
    if (!self.selectedProvince) {
        self.selectedProvince = self.model.areas.firstObject;
        self.selectedCitys = self.selectedProvince.subAreas;
        self.selectedCity = self.selectedCitys.firstObject;
        self.selectedCounties = self.selectedCity.subAreas;
        self.selectedCounty = self.selectedCounties.firstObject;
        return;
    }
    [self.selectedCitys enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.city.areaID isEqualToString:subArea.areaID]) {
            self.selectedCity = subArea;
            self.selectedCounties = self.selectedCity.subAreas;
            *stop = YES;
        }
    }];
    [self.selectedCounties enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.district.areaID isEqualToString:subArea.areaID]) {
            self.selectedCounty = subArea;
            *stop = YES;
        }
    }];
    DDLogDebug(@"设置选中为%@省-%@市-%@区",self.selectedProvince.name,self.selectedCity.name,self.selectedCounty.name);
}

- (void)updateAreaWithCompleteBlock:(void (^)(NSError *))completeBlock {
    DDLogDebug(@"要选择地区:%@-%@-%@",self.selectedProvince.name,self.selectedCity.name,self.selectedCounty.name);
    [MineDataManager updateArea:[self configAreaID] completeBlock:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
}

-(NSString *)configAreaID {
    NSString *areaID = [NSString string];
    if (!isEmpty(self.selectedProvince.areaID)) {
        areaID = self.selectedProvince.areaID;
        if (!isEmpty(self.selectedCity.areaID)) {
            areaID = [NSString stringWithFormat:@"%@,%@",areaID,self.selectedCity.areaID];
            if (!isEmpty(self.selectedCounty.areaID)) {
                areaID = [NSString stringWithFormat:@"%@,%@",areaID,self.selectedCounty.areaID];
            }
        }
    }
    return areaID;
}

- (UserAreaSelectedInfoItem *)selectedInfoItem {
    UserAreaSelectedInfoItem *item = [[UserAreaSelectedInfoItem alloc]init];
    item.selectedProvinceRow = 0;
    item.selectedCityRow = 0;
    item.selectedCountyRow = 0;
    if (self.model.areas.count > 0) {
        if ([self.model.areas containsObject:self.selectedProvince]) {
            item.selectedProvinceRow = [self.model.areas indexOfObject:self.selectedProvince];
        }
    }
    if (self.selectedCitys.count > 0) {
        if ([self.selectedCitys containsObject:self.selectedCity]) {
            item.selectedCityRow = [self.selectedCitys indexOfObject:self.selectedCity];
        }
    }
    if (self.selectedCounties.count > 0) {
        if ([self.selectedCounties containsObject:self.selectedCounty]) {
            item.selectedCountyRow = [self.selectedCounties indexOfObject:self.selectedCounty];
        }
    }
    return item;
}
@end
