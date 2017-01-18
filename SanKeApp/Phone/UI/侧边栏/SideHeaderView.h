//
//  SideHeaderView.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
typedef void(^EditButtonActionBlock)(void);

@interface SideHeaderView : UIView
@property (nonatomic, strong) UserModel *model;
- (void)setEditButtonActionBlock:(EditButtonActionBlock)block;

@end
