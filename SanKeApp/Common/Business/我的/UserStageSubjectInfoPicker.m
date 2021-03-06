//
//  UserStageSubjectInfoPicker.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserStageSubjectInfoPicker.h"

#import "MineUserModel.h"

@implementation UserStageSubjectSelectedInfoItem
@end

@interface UserStageSubjectInfoPicker ()
@property (nonatomic, strong) NSArray *selectedSubjects;
@property (nonatomic, strong) FetchStageSubjectRequestItem_stage *stage;
@property (nonatomic, strong) FetchStageSubjectRequestItem_subject *subject;
@property (nonatomic, copy) UpdateStageSubjectBlock block;
@end


@implementation UserStageSubjectInfoPicker

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.stageSubjectItem.data.stages.count;
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
            return ((FetchStageSubjectRequestItem_stage *)self.stageSubjectItem.data.stages[row]).name;
        case 1:
            return ((FetchStageSubjectRequestItem_subject *)self.selectedSubjects[row]).name;
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
            if (self.stageSubjectItem.data.stages.count > row) {
                self.stage = self.stageSubjectItem.data.stages[row];
                if (self.stage.subjects.count > 0) {
                    self.selectedSubjects = self.stage.subjects;
                    self.subject = self.selectedSubjects[0];
                }else {
                    self.selectedSubjects = nil;
                    self.subject = nil;
                }
            }
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:NO];
        }
            break;
        case 1:
        {
            if (self.selectedSubjects.count > row) {
                self.subject = self.selectedSubjects[row];
            }else {
                self.subject = nil;
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

- (void)resetSelectedStageSubjectsWithUserModel:(MineUserModel *)userModel {
    [self.stageSubjectItem.data.stages enumerateObjectsUsingBlock:^(FetchStageSubjectRequestItem_stage *stage, NSUInteger idx, BOOL *stop) {
        if ([userModel.stage.stageID isEqualToString:stage.stageID]) {
            self.stage = stage;
            self.selectedSubjects = self.stage.subjects;
            *stop = YES;
        }
    }];
    if (!self.stage) {
        self.stage = self.stageSubjectItem.data.stages.firstObject;
        self.selectedSubjects = self.stage.subjects;
        self.subject = self.selectedSubjects.firstObject;
        return;
    }
    [self.selectedSubjects enumerateObjectsUsingBlock:^(FetchStageSubjectRequestItem_subject *subject, NSUInteger idx, BOOL *stop) {
        if ([userModel.subject.subjectID isEqualToString:subject.subjectID]) {
            self.subject = subject;
            *stop = YES;
        }
    }];
    DDLogDebug(@"设置为选中%@学段-%@学科",self.stage.name,self.subject.name);
}

- (void)setUpdateStageSubjectBlock:(UpdateStageSubjectBlock)block {
    self.block = block;
}

- (void)updateStageSubject {
    BLOCK_EXEC(self.block,self.stage.stageID,self.subject.subjectID);
}
- (UserStageSubjectSelectedInfoItem *)selectedInfoItem {
    UserStageSubjectSelectedInfoItem *item = [[UserStageSubjectSelectedInfoItem alloc]init];
    item.stageRow = 0;
    item.subjectRow = 0;
    if (self.stageSubjectItem.data.stages.count > 0) {
        if ([self.stageSubjectItem.data.stages containsObject:self.stage]) {
            item.stageRow = [self.stageSubjectItem.data.stages indexOfObject:self.stage];
        }
    }
    if (self.selectedSubjects.count > 0) {
        if ([self.selectedSubjects containsObject:self.subject]) {
            item.subjectRow = [self.selectedSubjects indexOfObject:self.subject];
        }
    }
    item.stage = self.stage;
    item.subject = self.subject;
    
    return item;
}

@end
