//
//  YXImagePickerController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "UIImage+YXImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImagePickerUtils.h"

@interface YXImagePickerController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) void (^completion)(UIImage *selectedImage);

@end

@implementation YXImagePickerController

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *))completion
{
    self.completion = completion;
    BaseViewController *viewController = (BaseViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![ImagePickerUtils deviceCameraAvailable]) {
            [(BaseViewController *)viewController showToast:@"设备不支持拍照功能！"];
            return;
        }
        self.imagePickerController.sourceType = sourceType;
        if (![ImagePickerUtils deviceCameraUsagePermissions]) {
            [(BaseViewController *)viewController showToast:@"相机权限受限\n请在设置-隐私-相机中开启"];
            return;
        }
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    }else {
        self.imagePickerController.sourceType = sourceType;
        if (![ImagePickerUtils devicePhotoLibraryUsagePermissions]) {
            [(BaseViewController *)viewController showToast:@"相册权限受限\n请在设置-隐私-相册中开启"];
            return;
        }
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)presentFromViewController:(UIViewController *)viewController pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImage *))completion {
    self.completion = completion;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![ImagePickerUtils deviceCameraAvailable]) {
            [(BaseViewController *)viewController showToast:@"设备不支持拍照功能！"];
            return;
        }
        self.imagePickerController.sourceType = sourceType;
        if (![ImagePickerUtils deviceCameraUsagePermissions]) {
            [(BaseViewController *)viewController showToast:@"相机权限受限\n请在设置-隐私-相机中开启"];
            return;
        }
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    }else {
        self.imagePickerController.sourceType = sourceType;
        if (![ImagePickerUtils devicePhotoLibraryUsagePermissions]) {
            [(BaseViewController *)viewController showToast:@"相册权限受限\n请在设置-隐私-相册中开启"];
            return;
        }
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    [self completionImagePick:picker image:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self completionImagePick:picker image:nil];
}

- (void)completionImagePick:(UIImagePickerController *)picker image:(UIImage *)image
{
    if (image && self.completion) {
        self.completion(image);
    }
    if (picker) {
        [picker dismissViewControllerAnimated:YES
                                   completion:nil];
    }
}

#pragma mark - setter

-(void)setAllowsEditing:(BOOL)allowsEditing {
    _allowsEditing = allowsEditing;
    self.imagePickerController.allowsEditing = _allowsEditing;
}

@end
