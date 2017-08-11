//
//  TeachingPageModel.m
//  SanKeApp
//
//  Created by ZLL on 2017/5/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TeachingPageModel.h"

@implementation TeachingPageModel


+ (NSArray *)TeachingPageModelsFromRawData:(GetBookInfoRequestItem *)item {
    NSMutableArray *volumArry = [NSMutableArray arrayWithCapacity:item.data.volums.count];
    
    if (item.data.volums.count > 0) {
        for (GetBookInfoRequestItem_Volum *volum in item.data.volums) {
            NSString *pageCount = [volum.pages componentsSeparatedByString:@","].lastObject;
            NSMutableArray *volumPageModelArry = [NSMutableArray arrayWithCapacity:pageCount.integerValue];
            
            for (GetBookInfoRequestItem_Unit *unit in volum.units) {
                //url 单元预览
                if (unit.url.count > 0) {
                    [unit.url enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Page *page, NSUInteger idx, BOOL * _Nonnull stop) {
                        TeachingPageModel *unitPage = [[TeachingPageModel alloc]init];
                        unitPage.pageUrl = page.pageUrl;
                        unitPage.pageIndex = page.pageIndex;
                        unitPage.mark = page.mark;
                        unitPage.pageTarget = [NSString stringWithFormat:@"%@,%@",volum.volumID,unit.unitID];
                        if (idx == 0) {
                            unitPage.isStart = YES;
                        }
                        if (idx == unit.url.count - 1) {
                            unitPage.isEnd = YES;
                        }
                        //标签
                        if (unit.label.count > 0) {
                            unitPage.pageLabel = [NSMutableArray arrayWithArray:unit.label];
                        }
                        [volumPageModelArry addObject:unitPage];
                    }];
                }
                //课
                for (GetBookInfoRequestItem_Course *course in unit.courses) {
                    if (course.url.count > 0) {
                        [course.url enumerateObjectsUsingBlock:^(GetBookInfoRequestItem_Page *page, NSUInteger idx, BOOL * _Nonnull stop) {
                            TeachingPageModel *coursePage = [[TeachingPageModel alloc]init];
                            coursePage.pageUrl = page.pageUrl;
                            coursePage.pageIndex = page.pageIndex;
                            coursePage.mark = page.mark;
                            coursePage.pageTarget = [NSString stringWithFormat:@"%@,%@,%@",volum.volumID,unit.unitID,course.courseID];
                            if (idx == 0) {
                                coursePage.isStart = YES;
                            }
                            if (idx == unit.url.count - 1) {
                                coursePage.isEnd = YES;
                            }
                            //标签
                            if (course.label.count > 0) {
                                coursePage.pageLabel = [NSMutableArray arrayWithArray:course.label];
                            }
                            [volumPageModelArry addObject:coursePage];
                        }];
                    }
                }
            }
            [volumArry addObject:volumPageModelArry];
        }
    }
    return volumArry.copy;
}
@end
