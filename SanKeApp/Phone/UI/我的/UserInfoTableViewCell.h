//
//  UserInfoTableViewCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedButtonActionBlock)(void);

@interface UserInfoTableViewCell : UITableViewCell

- (void)configTitle:(NSString *)title content:(NSString *)content;
- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block;
@end
