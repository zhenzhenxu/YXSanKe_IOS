//
//  PersonalCenterModel.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalCenterModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hasButton;


+ (PersonalCenterModel *)modelWithTitle:(NSString *)title hasButton:(BOOL)hasButtton;

@end
