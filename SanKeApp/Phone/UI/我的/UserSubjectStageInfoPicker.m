//
//  UserSubjectStageInfoPicker.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSubjectStageInfoPicker.h"

@implementation UserSubjectStageSelectedInfoItem
@end

@interface UserSubjectStageInfoPicker ()
@property (nonatomic, strong) NSArray *selectedSubjects;
@property (nonatomic, strong) FetchStageSubjectRequestItem_stage *selectedStage;
@property (nonatomic, strong) FetchStageSubjectRequestItem_subject *selectedSubject;
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
            return self.stageAndSubjectItem.data.stages.count;
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
            return ((FetchStageSubjectRequestItem_stage *)self.stageAndSubjectItem.data.stages[row]).name;
        case 1:
            return ((FetchStageSubjectRequestItem_subject *)self.selectedSubjects[row]).name;
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
            self.selectedSubjects = ((FetchStageSubjectRequestItem_stage *)self.stageAndSubjectItem.data.stages[row]).subjects;
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

- (void)resetSelectedSubjectsWithUserModel:(UserModel *)userModel {
    [self.stageAndSubjectItem.data.stages enumerateObjectsUsingBlock:^(FetchStageSubjectRequestItem_stage *stage, NSUInteger idx, BOOL *stop) {
        if ([userModel.stageID isEqualToString:stage.stageID]) {
            self.selectedStage = stage;
            self.selectedSubjects = self.selectedStage.subjects;
            *stop = YES;
        }
    }];
    [self.selectedSubjects enumerateObjectsUsingBlock:^(FetchStageSubjectRequestItem_subject *subject, NSUInteger idx, BOOL *stop) {
        if ([userModel.subjectID isEqualToString:subject.subjectID]) {
            self.selectedSubject = subject;
            *stop = YES;
        }
    }];
    DDLogDebug(@"选中了%@学段-%@学科",self.selectedStage.name,self.selectedStage.name);
}

- (UserSubjectStageSelectedInfoItem *)selectedItem {
    UserSubjectStageSelectedInfoItem *item = [[UserSubjectStageSelectedInfoItem alloc]init];
    item.selectedStageRow = 0;
    item.selectedSubjectRow = 0;
    if ([self.stageAndSubjectItem.data.stages containsObject:self.selectedStage]) {
        item.selectedStageRow = [self.stageAndSubjectItem.data.stages indexOfObject:self.selectedStage];
    } else if (self.stageAndSubjectItem.data.stages.count > 0) {
        self.selectedSubjects = ((FetchStageSubjectRequestItem_stage *)self.stageAndSubjectItem.data.stages[0]).subjects;
    }
    if ([self.selectedSubjects containsObject:self.selectedSubject]) {
        item.selectedStageRow = [self.selectedSubjects indexOfObject:self.selectedSubject];
    }
    return item;
}

- (void)updateStageWithCompleteBlock:(void (^)(NSError *))completeBlock {
    [MineDataManager updateStage:self.selectedStage.stageID subject:self.selectedSubject.subjectID completeBlock:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(completeBlock,error);
            return;
        }
        BLOCK_EXEC(completeBlock,nil);
    }];
    
}
@end
