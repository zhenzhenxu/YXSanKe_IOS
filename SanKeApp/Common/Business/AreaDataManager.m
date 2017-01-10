//
//  AreaDataManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AreaDataManager.h"

@implementation Area
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"subArea":@"subAreas"}];
}
@end

@implementation AreaModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"areas"}];
}
@end

@implementation AreaDataManager

+ (AreaModel *)areaModel {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area_data" ofType:@"json"];;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    AreaModel *model = [[AreaModel alloc] initWithData:data error:&error];
    return model;
}

@end
