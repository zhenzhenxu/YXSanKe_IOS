//
//  SKAlertView.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AlertView.h"
#import "SKAlertButton.h"
#import "SKAlertTitleLabel.h"

extern CGFloat const kDefaultContentViewWith;
typedef void(^ButtonActionBlock)(void);

@interface SKAlertView : AlertView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL hideWhenButtonClicked;

- (void)addButtonWithTitle:(NSString *)title style:(SKAlertButtonStyle)style action:(ButtonActionBlock)buttonActionBlock;
- (UIView *)generateDefaultView;
- (void)show;
- (void)show:(BOOL)animated;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
@end
