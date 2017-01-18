//
//  YXFileVideoItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileVideoItem.h"
#import "YXPlayerViewController.h"
#import "SaveRecordRequest.h"

@interface YXFileVideoItem()<YXPlayProgressDelegate,YXBrowserExitDelegate>
@property (nonatomic, strong) NSString *duration;
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
        [self saveRecord];
    }];
}

- (void)saveRecord {
    SaveRecordRequest *request = [[SaveRecordRequest alloc]init];
    request.watch_record = self.record;
    request.total_time = self.duration;
    request.resource_id = self.resourceID;
    [[RecordManager sharedInstance]addRecordRequest:request];
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
    self.duration = [NSString stringWithFormat:@"%@",@(duration)];
    self.record = [NSString stringWithFormat:@"%@",@(duration*progress)];
}

- (CGFloat)preProgress {
    return self.record.floatValue;
}

#pragma mark - YXBrowserExitDelegate 
- (void)browserExit {
    [self saveRecord];
}

@end
