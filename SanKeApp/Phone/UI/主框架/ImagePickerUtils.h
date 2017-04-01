//
//  ImagePickerUtils.h
//  SanKeApp
//
//  Created by ZLL on 2017/4/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePickerUtils : NSObject

/**
 相机功能是否可用

 @return YES表示可用,反之不可用
 */
+ (BOOL)deviceCameraAvailable;
/**
 相机权限是否开启

 @return YES表示权限开启,反之表示权限关闭
 */
+ (BOOL)deviceCameraUsagePermissions;

/**
 相册权限是否开启

 @return YES表示权限开启,反之表示权限关闭
 */
+ (BOOL)devicePhotoLibraryUsagePermissions;
@end
