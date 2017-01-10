//
//  FileDownloadHelper.m
//  TrainApp
//
//  Created by niuzhaowang on 2016/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "FileDownloadHelper.h"
#import "UrlDownloader.h"
#import "YXFileDownloadProgressView.h"

@interface FileDownloadHelper ()
@property (nonatomic, strong) UrlDownloader *downloader;
@property (nonatomic, weak) YXFileItemBase *fileItem;
@property (nonatomic, strong) YXFileDownloadProgressView *progressView;
@end

@implementation FileDownloadHelper

- (instancetype)init {
    return [self initWithFileItem:nil];
}

- (instancetype)initWithFileItem:(YXFileItemBase *)fileItem {
    if (self = [super init]) {
        self.fileItem = fileItem;
    }
    return self;
}

- (void)startDownloadWithCompleteBlock:(void(^)(NSString *path))completeBlock {
    self.downloader = [[UrlDownloader alloc]init];
    [self.downloader setModel:self.fileItem.url];
    NSString *des = [self.downloader desFilePath];
    NSData *desData = [NSData dataWithContentsOfFile:des];
    if (des && desData && desData.length > 0) {
        BLOCK_EXEC(completeBlock,des);
        return;
    }
    
    self.progressView = [[YXFileDownloadProgressView alloc] init];
    WEAK_SELF
    [RACObserve(self.downloader, progress) subscribeNext:^(id x) {
        STRONG_SELF
        self.progressView.progress = [x floatValue];
    }];
    [RACObserve(self.downloader, state) subscribeNext:^(id x) {
        STRONG_SELF
        if ([x intValue] == DownloadStatusFinished) {
            [self.progressView removeFromSuperview];
            BLOCK_EXEC(completeBlock,des);
        }
        
        if ([x intValue] == DownloadStatusFailed) {
            [self.progressView removeFromSuperview];
            [self.fileItem.baseViewController showToast:@"加载失败"];
        }
    }];
    self.progressView.frame = [UIScreen mainScreen].bounds;
    self.progressView.titleLabel.text  =@"文件加载中...";
    [self.fileItem.baseViewController.view.window addSubview:self.progressView];
    self.progressView.closeBlock = ^() {
        STRONG_SELF
        [self.downloader stop];
    };
    
    [self.downloader start];
}

@end
