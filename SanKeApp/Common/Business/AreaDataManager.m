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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"subArea":@"subAreas",@"number":@"areaID"}];
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

+ (void)fetchAreaWithProvinceID:(NSString *)provinceID cityID:(NSString *)cityID districtID:(NSString *)districtID completeBlock:(void(^)(Area *province,Area *city,Area *district))completeBlock {
    __block Area *province = nil;
    __block Area *city = nil;
    __block Area *district = nil;
    
    [[self areaModel].areas enumerateObjectsUsingBlock:^(Area *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:provinceID]) {
            province = obj;
            *stop = YES;
        }
    }];
    [province.subAreas enumerateObjectsUsingBlock:^(Area *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:cityID]) {
            city = obj;
            *stop = YES;
        }
    }];
    [city.subAreas enumerateObjectsUsingBlock:^(Area *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaID isEqualToString:districtID]) {
            district = obj;
            *stop = YES;
        }
    }];
    BLOCK_EXEC(completeBlock,province,city,district);
}

@end
