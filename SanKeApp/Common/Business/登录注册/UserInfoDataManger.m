//
//  UserInfoDataManger.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserInfoDataManger.h"

@implementation UserInfo
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"subArea":@"subAreas",@"number":@"areaID"}];
}
@end

@implementation UserInfoModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"areas"}];
}
@end

@implementation UserInfoDataManger

+ (AreaModel *)areaModel {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area_data" ofType:@"json"];;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    AreaModel *model = [[AreaModel alloc] initWithData:data error:&error];
    return model;
}

@end
