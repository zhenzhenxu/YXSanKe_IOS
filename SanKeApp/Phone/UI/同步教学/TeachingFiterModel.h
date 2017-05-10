//
//  TeachingFiterModel.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeachingFilter : NSObject
@property (nonatomic, strong) NSString *filterID;
@property (nonatomic, strong) NSString *name;
@end

@interface TeachingFiterGroup : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *filterArray;
@end

@interface TeachingFiterModel : NSObject
@property (nonatomic, strong) NSArray *groupArray;

//+ (YXCourseListFilterModel *)modelFromRawData:(YXCourseListRequestItem *)item;
+ (TeachingFiterModel *)mockFilterData;
@end
