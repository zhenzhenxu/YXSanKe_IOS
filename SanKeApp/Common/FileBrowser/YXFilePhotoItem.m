//
//  YXFilePhotoItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFilePhotoItem.h"
#import "FileDownloadHelper.h"
#import "YXImageViewController.h"

@interface YXFilePhotoItem ()
@property (nonatomic, strong) FileDownloadHelper *downloadHelper;
@end

@implementation YXFilePhotoItem

- (void)openFile {
    if (self.isLocal) {
        [self openPic:self.url];
    }else {
        self.downloadHelper = [[FileDownloadHelper alloc]initWithFileItem:self];
        WEAK_SELF
        [self.downloadHelper startDownloadWithCompleteBlock:^(NSString *path) {
            STRONG_SELF
            [self openPic:path];
        }];
    }
}

- (void)openPic:(NSString *)path{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        [self.baseViewController showToast:@"该文件无法预览"];
        return;
    }
    YXImageViewController *vc = [[YXImageViewController alloc] init];
    id favorData = [self valueForKey:@"favorData"];
    if (favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    vc.image = image;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.title = self.name;
    
    SKNavigationController *navi = [[SKNavigationController alloc]initWithRootViewController:vc];
    [[self.baseViewController visibleViewController] presentViewController:navi animated:YES completion:nil];
}

@end
