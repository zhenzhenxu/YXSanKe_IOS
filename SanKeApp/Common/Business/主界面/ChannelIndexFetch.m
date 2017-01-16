//
//  ChannelIndexFetch.m
//  SanKeApp
//
//  Created by 郑小龙 on 17/1/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ChannelIndexFetch.h"
@interface ChannelIndexFetch ()
@property (nonatomic, strong) ChannelIndexRequest *indexRequest;
@end
@implementation ChannelIndexFetch
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.indexRequest stopRequest];
    self.indexRequest = [[ChannelIndexRequest alloc] init];
    self.indexRequest.subject = self.subject;
    self.indexRequest.stage = self.stage;
    self.indexRequest.page_size = self.page_size;
    self.indexRequest.last_id = self.last_id;
    WEAK_SELF
    [self.indexRequest startRequestWithRetClass:[ChannelIndexRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        ChannelIndexRequestItem *item = retItem;
        BLOCK_EXEC(aCompleteBlock,item.data.moreData.intValue,item.data.elements,nil);
    }];
}
@end
