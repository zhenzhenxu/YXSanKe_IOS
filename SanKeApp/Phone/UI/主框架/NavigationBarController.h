//
//  NavigationBarController.h
//  SanKeApp
//
//  Created by niuzhaowang on 2016/12/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^actionBlock)();

@interface NavigationBarController : NSObject
+ (void)setLeftWithNavigationItem:(UINavigationItem *)item imageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(actionBlock)action;

+ (void)setLeftWithNavigationItem:(UINavigationItem *)item customView:(UIView *)view;

+ (void)setRightWithNavigationItem:(UINavigationItem *)item imageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(actionBlock)action;

+ (void)setRightWithNavigationItem:(UINavigationItem *)item title:(NSString *)title action:(actionBlock)action;

+ (void)setRightWithNavigationItem:(UINavigationItem *)item customView:(UIView *)view;

+ (void)enableRightNavigationItem:(UINavigationItem *)naviItem;
+ (void)disableRightNavigationItem:(UINavigationItem *)naviItem;

// 以下2方法目前仅为附件收藏使用，其它地方不要使用
+ (UIButton *)naviButtonForTitle:(NSString *)title;
+ (NSArray *)barButtonItemsForView:(UIView *)view;
@end
