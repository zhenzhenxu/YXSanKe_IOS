//
//  RecordManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RecordManager.h"

NSString * const kRecordReportCompleteNotification = @"kRecordReportCompleteNotification";
NSString * const kRecordReportSuccessNotification = @"kRecordReportSuccessNotification";
NSString * const kRecordNeedUpdateNotification = @"kRecordNeedUpdateNotification";

@interface RecordManager()
@property (nonatomic, strong) NSMutableArray<__kindof SaveRecordRequest *> *requestArray;
@end

@implementation RecordManager
+ (RecordManager *)sharedInstance {
    static dispatch_once_t once;
    static RecordManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[RecordManager alloc] init];
        sharedInstance.requestArray = [NSMutableArray array];
    });
    
    return sharedInstance;
}

- (void)addRecordRequest:(SaveRecordRequest *)request {
    [self.requestArray addObject:request];
    if (self.isActive) {
        return;
    }
    [self checkAndStart];
    self.isActive = YES;
}

- (void)checkAndStart {
    if (self.requestArray.count > 0) {
        SaveRecordRequest *request = self.requestArray.firstObject;
        NSString *resourceID = request.resource_id;
        WEAK_SELF
        [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kRecordReportSuccessNotification object:nil userInfo:@{@"resourceID":resourceID}];
            }
            [self.requestArray removeObjectAtIndex:0];
            if (self.requestArray.count == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kRecordReportCompleteNotification object:nil];
                self.isActive = NO;
                return;
            }
            [self checkAndStart];
        }];
    }
}

@end
