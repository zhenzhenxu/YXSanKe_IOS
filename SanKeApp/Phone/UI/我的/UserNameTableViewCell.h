//
//  UserNameTableViewCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickBlock)(UITextField *nameTextField);
typedef void(^ChangeNameBlock)(NSString *name);

@interface UserNameTableViewCell : UITableViewCell

- (void)configTitle:(NSString *)title content:(NSString *)content;
- (void)setChangeNameBlock:(ChangeNameBlock)block;
- (void)setClickBlock:(ClickBlock)block;
@end
