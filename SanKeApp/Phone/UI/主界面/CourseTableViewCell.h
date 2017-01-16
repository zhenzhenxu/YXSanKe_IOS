//
//  CourseTableViewCell.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianBaseCell.h"
#import "ChannelIndexRequest.h"
@interface CourseTableViewCell : RadianBaseCell
@property (nonatomic, strong) ChannelIndexRequestItem_Data_Elements *element;
@property (nonatomic, copy) void(^ClickCourseTitleBlock)();

@end
