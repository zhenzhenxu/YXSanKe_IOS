//
//  RecordManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaveRecordRequest.h"

extern NSString * const kRecordReportCompleteNotification;
extern NSString * const kRecordReportSuccessNotification;
extern NSString * const kRecordNeedUpdateNotification;

@interface RecordManager : NSObject
+ (RecordManager *)sharedInstance;

@property (nonatomic, assign) BOOL isActive;
- (void)addRecordRequest:(SaveRecordRequest *)request;

@end
