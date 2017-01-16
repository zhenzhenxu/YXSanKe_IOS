//
//  UserSubjectStageInfoPicker.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSubjectStageInfoPicker.h"
#import "StageAndSubjectRequest.h"

@implementation UserSubjectStageSelectedInfoItem
@end

@interface UserSubjectStageInfoPicker ()
@property (nonatomic, strong) NSArray *selectedSubjects;
@property (nonatomic, strong) StageAndSubjectItem_Stage *selectedStage;
@property (nonatomic, strong) StageAndSubjectItem_Stage_Subject *selectedSubject;
@end

@implementation UserSubjectStageInfoPicker
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.stageAndSubjectItem.stages.count;
        case 1:
            return self.selectedSubjects.count;
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
            return ((StageAndSubjectItem_Stage *)self.stageAndSubjectItem.stages[row]).name;
        case 1:
            return ((StageAndSubjectItem_Stage_Subject *)self.selectedSubjects[row]).name;
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
            self.selectedSubjects = ((StageAndSubjectItem_Stage *)self.stageAndSubjectItem.stages[row]).subjects;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:NO];
        }
            break;
        case 1:
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

//- (void)resetSelectedSubjectsWithProfile:(YXUserProfile *)profile
//{
//    [self.stageAndSubjectItem.stages enumerateObjectsUsingBlock:^(StageAndSubjectItem_Stage *stage, NSUInteger idx, BOOL *stop) {
//        if ([profile.stageId isEqualToString:stage.sid]) {
//            self.selectedStage = stage;
//            self.selectedSubjects = self.selectedStage.subjects;
//            *stop = YES;
//        }
//    }];
//    [self.selectedSubjects enumerateObjectsUsingBlock:^(StageAndSubjectItem_Stage_Subject *subject, NSUInteger idx, BOOL *stop) {
//        if ([profile.subjectId isEqualToString:subject.sid]) {
//            self.selectedSubject = subject;
//            *stop = YES;
//        }
//    }];
//}

- (UserSubjectStageSelectedInfoItem *)selectedItem {
    UserSubjectStageSelectedInfoItem *item = [[UserSubjectStageSelectedInfoItem alloc]init];
    item.selectedStageRow = 0;
    item.selectedSubjectRow = 0;
    if ([self.stageAndSubjectItem.stages containsObject:self.selectedStage]) {
        item.selectedStageRow = [self.stageAndSubjectItem.stages indexOfObject:self.selectedStage];
    } else if (self.stageAndSubjectItem.stages.count > 0) {
        self.selectedSubjects = ((StageAndSubjectItem_Stage *)self.stageAndSubjectItem.stages[0]).subjects;
    }
    
    if ([self.selectedSubjects containsObject:self.selectedSubject]) {
        item.selectedStageRow = [self.selectedSubjects indexOfObject:self.selectedSubject];
    }
    return item;
}
@end
