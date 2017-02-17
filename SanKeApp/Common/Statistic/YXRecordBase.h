//
//  YXRecordBase.h
//  StatisticDemo
//
//  Created by niuzhaowang on 16/5/31.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 *  上报类型
 */
typedef NS_ENUM(NSInteger, YXRecordType) {
    /**
     *  Click点击
     */
    YXRecordTabType    = 1,
    /**
     *  首次进入板块页面
     */
    YXRecordPlateType      = 2,
    /**
     *  学科学段
     */
    YXRecordGradeType = 3,
    /**
     *  学科学点
     */
    YXRecordPointType = 4,
};

// record strategy enumeration
typedef NS_ENUM(NSUInteger, YXRecordStrategy) {
    YXRecordStrategyInstant,
    YXRecordStrategyRegular
};

@interface YXRecordBase : JSONModel

@property (nonatomic, assign) YXRecordStrategy strategy; // default is YXRecordStrategyInstant
@property (nonatomic, assign) BOOL shouldKeepLog;  // default is YES
@property (nonatomic, assign) YXRecordType type;

@property (nonatomic, copy) NSString *eventID;

+ (NSString *)timestamp;

@end
