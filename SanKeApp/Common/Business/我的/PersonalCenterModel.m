//
//  PersonalCenterModel.m
//  SanKeApp
//
//  Created by ZLL on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PersonalCenterModel.h"

@implementation PersonalCenterModel

+ (PersonalCenterModel *)modelWithTitle:(NSString *)title hasButton:(BOOL)hasButtton {
    PersonalCenterModel *model = [[PersonalCenterModel alloc]init];
    model.title = title;
    model.hasButton = hasButtton;
    return model;
}
@end
