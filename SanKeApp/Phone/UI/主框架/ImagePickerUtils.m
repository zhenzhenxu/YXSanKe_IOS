//
//  ImagePickerUtils.m
//  SanKeApp
//
//  Created by ZLL on 2017/4/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ImagePickerUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ImagePickerUtils

+ (BOOL)deviceCameraAvailable {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    }
    return NO;
}

+ (BOOL)deviceCameraUsagePermissions {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied
        || authStatus == AVAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}

+ (BOOL)devicePhotoLibraryUsagePermissions {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}
@end
