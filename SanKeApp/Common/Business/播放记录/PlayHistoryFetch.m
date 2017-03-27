//
//  PlayHistoryFetch.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PlayHistoryFetch.h"
#import "PlayHistoryRequest.h"
@interface PlayHistoryFetch ()
@property (nonatomic, strong) PlayHistoryRequest *historyRequest;
@end
@implementation PlayHistoryFetch
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.historyRequest stopRequest];
    self.historyRequest = [[PlayHistoryRequest alloc] init];
    self.historyRequest.pageSize = self.pageSize;
    self.historyRequest.pageNum = self.pageNum+1;
    WEAK_SELF
    [self.historyRequest startRequestWithRetClass:[PlayHistoryRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        PlayHistoryRequestItem *item = retItem;
        if (item.data.history.count == 0) {
            BLOCK_EXEC(self.ListCompleteBlock,nil);
        }
        NSInteger total = 0;
        if (item.data.moreData.integerValue == 1) {
            total = NSIntegerMax;
        }
        BLOCK_EXEC(aCompleteBlock,total,item.data.history,nil);
    }];
}

@end
