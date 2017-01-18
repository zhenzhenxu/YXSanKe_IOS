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
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.historyRequest stopRequest];
    self.historyRequest = [[PlayHistoryRequest alloc] init];
    self.historyRequest.pageSize = self.pageSize;
    self.historyRequest.lastID = self.lastID;
    WEAK_SELF
    [self.historyRequest startRequestWithRetClass:[PlayHistoryRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        PlayHistoryRequestItem *item = retItem;
        BLOCK_EXEC(aCompleteBlock,item.data.moreData.intValue,item.data.history,nil);
    }];
}

@end
