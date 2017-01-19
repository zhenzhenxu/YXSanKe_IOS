//
//  SideTableViewModel.m
//  SanKeApp
//
//  Created by ZLL on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SideTableViewModel.h"

@implementation SideTableViewModel
+(SideTableViewModel *)modelWithIcon:(NSString *)icon title:(NSString *)title {
    SideTableViewModel *model = [[SideTableViewModel alloc]init];
    model.icon = icon;
    model.title = title;
    return model;
}
@end
