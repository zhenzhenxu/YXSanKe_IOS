//
//  UserSubjectStageInfoPicker.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MineUserModel;

@interface UserSubjectStageSelectedInfoItem : NSObject
@property (nonatomic, assign) NSInteger stageRow;
@property (nonatomic, assign) NSInteger subjectRow;
@property (nonatomic, strong) FetchStageSubjectRequestItem_stage *stage;
@property (nonatomic, strong) FetchStageSubjectRequestItem_subject *subject;
@end

@interface UserSubjectStageInfoPicker : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) FetchStageSubjectRequestItem *stageAndSubjectItem;

- (void)resetSelectedSubjectsWithUserModel:(MineUserModel *)userModel;
- (void)updateStageWithCompleteBlock:(void(^)(NSError *error))completeBlock;

- (UserSubjectStageSelectedInfoItem *)selectedInfoItem;
@end
