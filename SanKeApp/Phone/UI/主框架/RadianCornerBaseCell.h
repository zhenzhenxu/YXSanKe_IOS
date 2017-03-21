//
//  RadianCornerBaseCell.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadianCornerBaseCell : UITableViewCell
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) CGFloat seperatorHeight; // default is 1.0
- (void)setupUI;
- (void)updateWithCurrentIndex:(NSInteger)index total:(NSInteger)total;
@end
