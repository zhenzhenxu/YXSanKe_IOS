//
//  PhotoBrowserController.h
//  SanKeApp
//
//  Created by LiuWenXing on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "TeachingPageModel.h"

extern NSString * const kPhotoBrowserExitNotification;
extern NSString * const kPhotoBrowserIndexKey;

@interface PhotoBrowserController : BaseViewController

@property (nonatomic, strong) NSArray<TeachingPageModel *> *currentVolumDataArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end
