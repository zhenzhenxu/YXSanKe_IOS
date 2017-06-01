//
//  LabelListViewController.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
@class GetBookInfoRequestItem_Label;
@class GetBookInfoRequestItem_Volum;
@class GetBookInfoRequestItem_Unit;
@class GetBookInfoRequestItem_Course;

@interface LabelListViewController : BaseViewController
@property (nonatomic, strong)  NSArray <GetBookInfoRequestItem_Label *> *tabArray;
@property (nonatomic, assign)  NSInteger currentTabIndex;

@property (nonatomic, strong) GetBookInfoRequestItem_Volum *volum;
@property (nonatomic, strong) GetBookInfoRequestItem_Unit *unit;
@property (nonatomic, strong) GetBookInfoRequestItem_Course *course;
@end
