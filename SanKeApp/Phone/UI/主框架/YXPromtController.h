//
//  YXPromtController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXPromtController : NSObject

+ (void)startLoadingInView:(UIView *)view;
+ (void)stopLoadingInView:(UIView *)view;
+ (void)showToast:(NSString *)text inView:(UIView *)view;

@end
