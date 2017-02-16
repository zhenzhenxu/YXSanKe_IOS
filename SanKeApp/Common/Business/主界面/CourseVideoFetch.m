//
//  ChannelvideoFetch.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseVideoFetch.h"
@interface CourseVideoFetch ()
@property (nonatomic, strong) CourseVideoRequest *videoRequest;
@end
@implementation CourseVideoFetch

- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.videoRequest stopRequest];
    self.videoRequest = [[CourseVideoRequest alloc] init];
    self.videoRequest.filterID = self.filterID.length? self.filterID: @"0,0,0";
    self.videoRequest.catID = self.catID;
    self.videoRequest.fromType = self.fromType;
    if (self.fromType == 0) {
        self.videoRequest.filterID = @"0,0,0";
    }
    self.videoRequest.pageSize = self.pageSize;
    self.videoRequest.lastID = self.lastID;
    WEAK_SELF
    [self.videoRequest startRequestWithRetClass:[CourseVideoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        CourseVideoRequestItem *item = retItem;
        BLOCK_EXEC(aCompleteBlock,item.data.moreData.intValue,item.data.items,nil);
    }];
}
@end
