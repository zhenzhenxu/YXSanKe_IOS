//
//  QAUtils.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QAUtils.h"

@implementation QAUtils

+ (NSString *)formatTimeWithOriginal:(NSString *)originalTime {
    NSArray *array = [originalTime componentsSeparatedByString:@" "];
    return array.firstObject;
}
@end
