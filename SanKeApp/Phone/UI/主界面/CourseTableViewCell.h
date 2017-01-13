//
//  CourseTableViewCell.h
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianBaseCell.h"

@interface CourseTableViewCell : RadianBaseCell
@property (nonatomic, copy) void(^ClickCourseTitleBlock)();
- (void)setupMokeData:(NSString *)string;
@end
