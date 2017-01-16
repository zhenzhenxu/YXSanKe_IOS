//
//  UserAreaInfoPicker.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserAreaInfoPicker.h"
#import "AreaDataManager.h"
@interface UserAreaInfoPicker ()

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
    self.integer = row;
    return pickerLabel;
}

- (void)setSelectedProvince:(Area *)selectedProvince {
    _selectedProvince = selectedProvince;
    self.selectedCitys = selectedProvince.subAreas;
    self.selectedCounties = self.selectedCitys[0].subAreas;
}
- (void)selectRow:(UIPickerView *)view  {
       [view selectRow:self.integer inComponent:0 animated:NO];
}
@end
