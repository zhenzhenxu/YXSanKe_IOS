//
//  StageAndSubjectRequest.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StageAndSubjectRequest.h"
@implementation StageAndSubjectItem_Stage_Subject

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"sid"}];
}

@end

@implementation StageAndSubjectItem_Stage

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"sid"}];
}

@end

@implementation StageAndSubjectItem

@end

@implementation StageAndSubjectRequest

- (instancetype)init
{
    if (self = [super init]) {
//        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"stageSubject"];
    }
    return self;
}

@end
