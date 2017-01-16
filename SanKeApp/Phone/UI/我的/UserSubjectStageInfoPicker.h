//
//  UserSubjectStageInfoPicker.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StageAndSubjectItem;
@interface UserSubjectStageSelectedInfoItem : NSObject
@property (nonatomic, assign) NSInteger selectedStageRow;
@property (nonatomic, assign) NSInteger selectedSubjectRow;

@end

@interface UserSubjectStageInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) StageAndSubjectItem *stageAndSubjectItem;
//- (void)resetSelectedSubjectsWithProfile:(YXUserProfile *)profile;//设置选中的学科学段
- (UserSubjectStageSelectedInfoItem *)selectedItem;
@end
