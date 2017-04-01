//
//  YXImagePickerController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YXImagePickerController : NSObject

@property (nonatomic, assign) BOOL allowsEditing;//是否对照片进行裁剪,默认裁剪,传NO表示不裁剪

/**
 照片选择器

 @param sourceType 要打开的类型(相册/相机)
 @param completion 回调
 */
- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void(^)(UIImage *selectedImage))completion;

/**
 照片选择器

 @param viewController 当前要弹出照片选择器的控制器
 @param sourceType 要打开的类型(相册/相机)
 @param completion 回调
 */
- (void)presentFromViewController:(UIViewController *)viewController pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImage *selectedImage))completion;

@end
