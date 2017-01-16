//
//  SideTableViewModel.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SideTableViewModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;

+ (SideTableViewModel *)modelWithIcon:(NSString *)icon title:(NSString *)title;

@end
