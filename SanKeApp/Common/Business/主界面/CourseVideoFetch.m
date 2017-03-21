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

- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.videoRequest stopRequest];
    self.videoRequest = [[CourseVideoRequest alloc] init];
    self.videoRequest.filterID = self.filterID.length? self.filterID: @"0,0,0,0";
    self.videoRequest.catID = self.catID;
    self.videoRequest.fromType = self.fromType;
    if (self.fromType == 0) {
        self.videoRequest.filterID = @"0,0,0,0";
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
        CourseVideoRequestItem_Data_Elements *element = item.data.items.lastObject;
        self.lastID = element.itemID.integerValue;
        NSInteger total = 0;
        if (item.data.moreData.integerValue == 1) {
            total = NSIntegerMax;
        }
        BLOCK_EXEC(aCompleteBlock,total,item.data.items,nil);
    }];
}

@end
