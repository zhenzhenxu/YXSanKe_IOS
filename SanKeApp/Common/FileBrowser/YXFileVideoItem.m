//
//  YXFileVideoItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileVideoItem.h"
#import "YXPlayerViewController.h"

@interface YXFileVideoItem()<YXPlayProgressDelegate,YXBrowserExitDelegate>

@end

@implementation YXFileVideoItem

- (instancetype)init {
    if (self = [super init]) {
        [self setupObserver];
    }
    return self;
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [[NSNotificationCenter defaultCenter]postNotificationName:kRecordNeedUpdateNotification object:nil];
        // 添加上报请求
    }];
}

- (void)openFile {
    YXPlayerViewController *vc = [[YXPlayerViewController alloc] init];
    id favorData = [self valueForKey:@"favorData"];
    if (favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    vc.videoUrl = self.url;
    
    YXPlayerDefinition *d0 = [[YXPlayerDefinition alloc] init];
    d0.identifier = @"流畅";
    d0.url = self.lurl;
    
    YXPlayerDefinition *d1 = [[YXPlayerDefinition alloc] init];
    d1.identifier = @"标清";
    d1.url = self.murl;
    
    YXPlayerDefinition *d2 = [[YXPlayerDefinition alloc] init];
    d2.identifier = @"高清";
    d2.url = self.surl;
    
    vc.definitionArray = @[d0, d1, d2];
    
    vc.title = self.name;
    vc.delegate = self;
    vc.exitDelegate = self;
    [[self.baseViewController visibleViewController] presentViewController:vc animated:YES completion:nil];
}

#pragma mark - YXPlayProgressDelegate
- (void)playerProgress:(CGFloat)progress totalDuration:(NSTimeInterval)duration stayTime:(NSTimeInterval)time {
    
}

- (CGFloat)preProgress {
    return 0;
}

#pragma mark - YXBrowserExitDelegate 
- (void)browserExit {
    // 添加上报请求
}

@end
