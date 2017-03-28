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

@interface YXImagePickerController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) void (^completion)(UIImage *selectedImage);
@property (nonatomic, assign) BOOL isPublish;

@end

@implementation YXImagePickerController

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *))completion
{
    self.isPublish = NO;
    BaseViewController *viewController = (BaseViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
            [viewController showToast:@"相册权限受限\n请在设置-隐私-相册中开启"];
            return;
        }
        self.imagePickerController.sourceType = sourceType;
        self.completion = completion;
        
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [viewController showToast:@"设备不支持拍照功能！"];
    }
}

- (void)superViewController:(UIViewController *)viewController pickImagePublishWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImage *))completion
{
    self.isPublish = YES;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePickerController.sourceType = sourceType;
        self.imagePickerController.allowsEditing = NO;
        self.completion = completion;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusDenied
                || authStatus == AVAuthorizationStatusRestricted) {
                [(BaseViewController *)viewController showToast:@"相机权限受限\n请在设置-隐私-相机中开启"];
                return;
            }
            [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
        }else{
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
                [(BaseViewController *)viewController showToast:@"相册权限受限\n请在设置-隐私-相册中开启"];
                return;
            }
            self.completion(nil);
        }
    } else {
        [(BaseViewController *)viewController showToast:@"设备不支持拍照功能！"];
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

#pragma mark -

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

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.isPublish) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        image = [image scaleToSize:[self getImageSizeWithImage:image]];
    }

    [self completionImagePick:picker image:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self completionImagePick:picker image:nil];
}

- (CGSize)getImageSizeWithImage:(UIImage *)image
{
    CGSize gSize;
    CGSize size = image.size;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    gSize.width = screenSize.width * [UIScreen mainScreen].scale;
    gSize.height = gSize.width/(size.width/size.height);
    return gSize;
}

@end
