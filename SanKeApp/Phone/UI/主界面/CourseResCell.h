//
//  CourseResCell.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/8/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RadianCornerBaseCell.h"

@interface CourseResCell : RadianCornerBaseCell

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void(^clickBlock)(CourseResCell *cell);

@end
