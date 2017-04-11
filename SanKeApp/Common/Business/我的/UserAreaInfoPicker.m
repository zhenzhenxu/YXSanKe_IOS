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
@property (nonatomic, strong) Area *province;
@property (nonatomic ,strong)NSArray<Area *> *cityArray;
@property (nonatomic ,strong)NSArray<Area *> *districtArray;
@property (nonatomic, strong) Area *city;
@property (nonatomic, strong) Area *district;

@property (nonatomic, copy) UpdateAreaBlock block;
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
            return self.cityArray.count;
        case 2:
            return self.districtArray.count;
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
            return self.cityArray[row].name;
            
        }
        case 2:
        {
            
            return self.districtArray[row].name;
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
                self.province = self.model.areas[row];
                if (self.province.subAreas.count > 0) {
                    self.cityArray = self.province.subAreas;
                    self.city = self.cityArray[0];
                    if (self.city.subAreas.count > 0) {
                        self.districtArray = self.city.subAreas;
                        self.district = self.districtArray[0];
                    }else {
                        self.districtArray = nil;
                        self.district = nil;
                    }
                }else {
                    self.cityArray = nil;
                    self.city = nil;
                    self.districtArray = nil;
                    self.district = nil;
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
            if (self.cityArray.count > row){
                self.city = self.cityArray[row];
                if (self.city.subAreas.count > 0) {
                    self.districtArray = self.city.subAreas;
                    self.district = self.districtArray[0];
                }else{
                    self.districtArray = nil;
                    self.district = nil;
                }
            }
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:NO];
        }
            break;
        case 2:
        {
            if (self.districtArray.count > row){
                self.district = self.districtArray[row];
            }else {
                self.district = nil;
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
    ((UILabel *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    ((UILabel *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    return pickerLabel;
}

- (void)resetSelectedProvinceDataWithUserModel:(MineUserModel *)userModel {
    [self.model.areas enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.province.areaID isEqualToString:subArea.areaID]) {
            self.province = subArea;
            self.cityArray = self.province.subAreas;
            *stop = YES;
        }
    }];
    if (!self.province) {
        self.province = self.model.areas.firstObject;
        self.cityArray = self.province.subAreas;
        self.city = self.cityArray.firstObject;
        self.districtArray = self.city.subAreas;
        self.district = self.districtArray.firstObject;
        return;
    }
    [self.cityArray enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.city.areaID isEqualToString:subArea.areaID]) {
            self.city = subArea;
            self.districtArray = self.city.subAreas;
            *stop = YES;
        }
    }];
    [self.districtArray enumerateObjectsUsingBlock:^(Area *subArea, NSUInteger idx, BOOL *stop) {
        if ([userModel.district.areaID isEqualToString:subArea.areaID]) {
            self.district = subArea;
            *stop = YES;
        }
    }];
    DDLogDebug(@"设置选中为%@省-%@市-%@区",self.province.name,self.city.name,self.district.name);
}

- (void)setUpdateAreaBlock:(UpdateAreaBlock)block {
    self.block = block;
}

- (void)updateArea {
    BLOCK_EXEC(self.block,[self configAreaID]);
}

-(NSString *)configAreaID {
    NSString *areaID = [NSString string];
    if (!isEmpty(self.province.areaID)) {
        areaID = self.province.areaID;
        if (!isEmpty(self.city.areaID)) {
            areaID = [NSString stringWithFormat:@"%@,%@",areaID,self.city.areaID];
            if (!isEmpty(self.district.areaID)) {
                areaID = [NSString stringWithFormat:@"%@,%@",areaID,self.district.areaID];
            }
        }
    }
    return areaID;
}

- (UserAreaSelectedInfoItem *)selectedInfoItem {
    UserAreaSelectedInfoItem *item = [[UserAreaSelectedInfoItem alloc]init];
    item.provinceRow = 0;
    item.cityRow = 0;
    item.districtRow = 0;
    if (self.model.areas.count > 0) {
        if ([self.model.areas containsObject:self.province]) {
            item.provinceRow = [self.model.areas indexOfObject:self.province];
        }
    }
    if (self.cityArray.count > 0) {
        if ([self.cityArray containsObject:self.city]) {
            item.cityRow = [self.cityArray indexOfObject:self.city];
        }
    }
    if (self.districtArray.count > 0) {
        if ([self.districtArray containsObject:self.district]) {
            item.districtRow = [self.districtArray indexOfObject:self.district];
        }
    }
    item.province = self.province;
    item.city = self.city;
    item.district = self.district;
    return item;
}

@end
