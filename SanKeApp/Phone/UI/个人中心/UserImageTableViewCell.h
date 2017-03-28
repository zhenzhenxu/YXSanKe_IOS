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
@property (nonatomic, assign) BOOL canEdit;//头像是否可以编辑
- (void)setEditBlock:(EditBlock)block;
@end
