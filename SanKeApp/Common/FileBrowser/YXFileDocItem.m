//
//  YXFileDocItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileDocItem.h"
#import "FileDownloadHelper.h"
#import "YXImageViewController.h"
#import "YXQLPreviewController.h"

@interface YXFileDocItem ()
@property (nonatomic, strong) FileDownloadHelper *downloadHelper;
@end

@implementation YXFileDocItem

- (void)openFile {
    if (self.isLocal) {
        [self openDoc:self.url];
    }else {
        self.downloadHelper = [[FileDownloadHelper alloc]initWithFileItem:self];
        WEAK_SELF
        [self.downloadHelper startDownloadWithCompleteBlock:^(NSString *path) {
            STRONG_SELF
            [self openDoc:path];
        }];
    }
}

- (void)openDoc:(NSString *)path{
    YXQLPreviewController *qlVC = [[YXQLPreviewController alloc]init];
    qlVC.qlUrl = path;
    qlVC.qlTitle = self.name;
    
    if (![qlVC canPreview]) {
        [self.baseViewController showToast:@"该文件无法预览"];
        return;
    }
    
    id favorData = [self valueForKey:@"favorData"];
    if (favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:favorData baseVC:qlVC];
        wrapper.delegate = self;
        qlVC.favorWrapper = wrapper;
    }
    [[self.baseViewController visibleViewController] presentViewController:qlVC animated:YES completion:nil];
}


@end
