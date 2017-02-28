//
//  UserImageTableViewCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineUserModel;
typedef void(^EditBlock)(void);

@interface UserImageTableViewCell : UITableViewCell

@property (nonatomic, strong) UserModel *model;
- (void)setEditBlock:(EditBlock)block;
@end
