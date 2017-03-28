//
//  PersonalCenterCell.h
//  SanKeApp
//
//  Created by ZLL on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedButtonActionBlock)(void);

@interface PersonalCenterCell : UITableViewCell

- (void)configTitle:(NSString *)title hasButton:(BOOL)hasButton;
- (void)setSelectedButtonActionBlock:(SelectedButtonActionBlock)block;


@end
