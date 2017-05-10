//
//  TeachingFiterModel.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingFiterModel.h"

@implementation TeachingFiterGroup

@end

@implementation TeachingFilter

@end

@implementation TeachingFiterModel

+ (TeachingFiterModel *)mockFilterData {
    // 学科
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        TeachingFilter *filter = [[TeachingFilter alloc]init];
        filter.filterID = @"";
        filter.name = @"";
        [array addObject:filter];
    }
    NSArray *volumeArray = @[
                             @"七年级上",
                             @"七年级下"
                             ];
    NSArray *unitArray = @[
                           @"第一单元 阅读",
                           @"第一单元 写作",
                           @"第二单元 阅读",
                           @"第二单元 写作",
                           @"第二单元 综合性学习",
                           @"第三单元 阅读",
                           @"第三单元 写作",
                           @"第三单元 名著导读",
                           @"第三单元 课外古诗词诵读",
                           @"第四单元 阅读",
                           @"第四单元 写作",
                           @"第四单元 综合性学习",
                           @"第五单元 阅读",
                           @"第五单元 写作",
                           @"第六单元 阅读",
                           @"第六单元 写作",
                           @"第六单元 综合性学习",
                           @"第六单元 名著导读",
                           @"第六单元 课外古诗词诵读"
                           ];
    NSArray *courseArray = @[
                             @"全部",
                             @"1 春/朱自清",
                             @"2 济南的春天/老舍",
                             @"第三课",
                             @"第四课",
                             @"第五课"
                             ];
    TeachingFiterGroup *group0 = [[TeachingFiterGroup alloc]init];
    group0.name = @"册";
    group0.filterArray = volumeArray;
    
    TeachingFiterGroup *group1 = [[TeachingFiterGroup alloc]init];
    group0.name = @"单元";
    group0.filterArray = unitArray;
    
    TeachingFiterGroup *group2 = [[TeachingFiterGroup alloc]init];
    group0.name = @"课";
    group0.filterArray = courseArray;
    
    TeachingFiterModel *model = [[TeachingFiterModel alloc]init];
    model.groupArray = @[group0,group1,group2];
    return model;
}

@end
