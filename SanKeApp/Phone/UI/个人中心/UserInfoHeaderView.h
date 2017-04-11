//
//  UserInfoHeaderView.h
//  SanKeApp
//
//  Created by ZLL on 2017/4/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^EditBlock)(void);

@interface UserInfoHeaderView : UIView
@property (nonatomic, strong) UserModel *model;
- (void)setEditBlock:(EditBlock)block;

@end
