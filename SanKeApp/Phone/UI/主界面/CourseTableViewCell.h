//
//  CourseTableViewCell.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianBaseCell.h"
#import "GetResListRequest.h"
@interface CourseTableViewCell : RadianBaseCell
@property (nonatomic, strong) GetResListRequestItem_Data_Element *element;
@property (nonatomic, copy) void(^ClickCourseTitleBlock)();

@end
