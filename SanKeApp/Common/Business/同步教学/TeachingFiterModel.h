//
//  TeachingFiterModel.h
//  SanKeApp
//
//  Created by ZLL on 2017/5/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetBookInfoRequest.h"

@interface TeachingFiterModel : NSObject
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Volum *> *volums;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Unit *> *units;
@property (nonatomic, strong) NSArray<GetBookInfoRequestItem_Course *> *courses;
@property (nonatomic, copy) NSString *volumName;
@property (nonatomic, copy) NSString *unitName;
@property (nonatomic, copy) NSString *courseName;
@property (nonatomic, assign) NSInteger volumChooseInteger;
@property (nonatomic, assign) NSInteger unitChooseInteger;
@property (nonatomic, assign) NSInteger courseChooseInteger;

+ (TeachingFiterModel *)modelFromRawData:(GetBookInfoRequestItem *)item;
@end
