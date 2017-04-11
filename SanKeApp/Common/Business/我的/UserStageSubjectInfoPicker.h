//
//  UserStageSubjectInfoPicker.h
//  SanKeApp
//
//  Created by ZLL on 2017/4/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MineUserModel;

typedef void(^UpdateStageSubjectBlock)(NSString *stageID,NSString *subjectID);

@interface UserStageSubjectSelectedInfoItem : NSObject
@property (nonatomic, assign) NSInteger stageRow;
@property (nonatomic, assign) NSInteger subjectRow;
@property (nonatomic, strong) FetchStageSubjectRequestItem_stage *stage;
@property (nonatomic, strong) FetchStageSubjectRequestItem_subject *subject;

@end

@interface UserStageSubjectInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) FetchStageSubjectRequestItem *stageSubjectItem;

- (void)resetSelectedStageSubjectsWithUserModel:(MineUserModel *)userModel;
- (void)setUpdateStageSubjectBlock:(UpdateStageSubjectBlock)block;
- (void)updateStageSubject;
- (UserStageSubjectSelectedInfoItem *)selectedInfoItem;

@end
