//
//  YXFileItemBase.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileItemBase.h"

@interface YXFileItemBase ()
@property (nonatomic, strong) id favorData;
@property (nonatomic, copy) void(^addFavorCompleteBlock)();
@end

@implementation YXFileItemBase

- (void)addFavorWithData:(id)data completion:(void(^)())completeBlock{
    self.favorData = data;
    self.addFavorCompleteBlock = completeBlock;
}

- (void)browseFile {
    if (self.isLocal) {
        [self openFile];
    }else {
        [self checkNetwork];
    }
}

- (void)openFile {
    
}

//- (void)setRecord:(NSString *)record{
//    _record = record;
//    NSArray *times = [record componentsSeparatedByString:@":"];
//    if (times.count >= 2) {
//        
//    }
//}

- (void)checkNetwork {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self.baseViewController showToast:@"网络异常,请稍候重试"];
        return;
    }
    
    if ([r isReachableViaWWAN] && ![r isReachableViaWiFi]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
        WEAK_SELF
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return;
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            [self openFile];
        }];
        [alertVC addAction:backAction];
        [alertVC addAction:goAction];
        [[self.baseViewController visibleViewController] presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    [self openFile];
}

#pragma mark - YXFileFavorDelegate
- (void)fileDidFavor{
    BLOCK_EXEC(self.addFavorCompleteBlock);
}

@end
