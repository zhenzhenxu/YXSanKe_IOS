//
//  UIImage+Color.h
//  Le123PhoneClient
//
//  Created by CaiLei on 1/7/14.
//  Copyright (c) 2014 Ying Shi Da Quan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+ (UIImage *)yx_imageWithColor:(UIColor *)aColor;
+ (UIImage *)yx_imageWithColor:(UIColor *)color rect:(CGRect)aRect;

- (UIImage *)yx_imageReplaceWithColor:(UIColor *)color;
- (UIImage *)yx_imageAddMaskWithTintColor:(UIColor *)tintColor;
@end
