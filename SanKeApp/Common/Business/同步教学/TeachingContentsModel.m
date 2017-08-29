//
//  TeachingContentsModel.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingContentsModel.h"

@implementation TeachingContentsModel

+ (TeachingContentsModel *)modelFromRawData:(GetBookInfoRequestItem *)item {
    TeachingContentsModel *model = [[TeachingContentsModel alloc]init];
    
    model.volums = item.data.volums;
    model.volumName = @"册";
    model.volumChooseInteger = 0;
    
    model.unitName = @"单元";
    model.unitChooseInteger = 0;
    
    model.courseName = @"课程";
    model.courseChooseInteger = 0;
    return model;
}

- (NSArray<GetBookInfoRequestItem_Unit *> *)units {
    return self.volums[self.volumChooseInteger].units;
}

- (NSArray<GetBookInfoRequestItem_Course *> *)courses {
    return self.units[self.unitChooseInteger].courses;
}

@end
