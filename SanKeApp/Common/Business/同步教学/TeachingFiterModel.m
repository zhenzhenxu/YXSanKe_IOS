//
//  TeachingFiterModel.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingFiterModel.h"

@implementation TeachingFiterModel

+ (TeachingFiterModel *)modelFromRawData:(GetBookInfoRequestItem *)item {
    TeachingFiterModel *model = [[TeachingFiterModel alloc]init];
    
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
    GetBookInfoRequestItem_Course *course = [[GetBookInfoRequestItem_Course alloc]init];
    course.name = @"全部";
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.units[self.unitChooseInteger].courses];
    [array insertObject:course atIndex:0];
    return array.copy;
}
@end
